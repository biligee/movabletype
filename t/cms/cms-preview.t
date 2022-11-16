#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";    # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;

BEGIN {
    $test_env = MT::Test::Env->new;
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT;
use MT::Test;
use MT::Test::Permission;
use MT::Test::App;
use Web::Query::LibXML;

$test_env->prepare_fixture('db');

my $blog_id = 1;
my $blog    = MT::Blog->load($blog_id);
$blog->site_path($test_env->root);
$blog->archive_path($test_env->root . '/archive');
$blog->archive_url('http://localhost/');
$blog->save;

my $admin = MT::Author->load(1);

my $author = MT::Test::Permission->make_author(
    name     => 'author',
    nickname => 'author',
);

# Entry
my $entry1 = MT::Test::Permission->make_entry(
    blog_id     => $blog->id,
    author_id   => $author->id,
    authored_on => '20180829000000',
    title       => 'entry',
    status      => MT::EntryStatus::RELEASE(),
);

# Content
my $content_type = MT::Test::Permission->make_content_type(blog_id => $blog_id);
my $cf_single    = MT::Test::Permission->make_content_field(
    blog_id         => 1,
    content_type_id => $content_type->id,
    name            => 'single',
    type            => 'single_line_text',
);
$content_type->fields([{
        id        => $cf_single->id,
        name      => $cf_single->name,
        options   => { label => $cf_single->name, },
        order     => 1,
        type      => $cf_single->type,
        unique_id => $cf_single->unique_id,
    },
]);
$content_type->save or die $content_type->errstr;

my $cd1 = MT::Test::Permission->make_content_data(
    blog_id         => $blog_id,
    content_type_id => $content_type->id,
    label           => 'label',
    data            => { $cf_single->id => 'single line text' },
    identifier      => 'my content data',
    status          => MT::ContentStatus::RELEASE(),
);

# Mapping
my $template1 = MT::Test::Permission->make_template(
    blog_id => $blog->id,
    name    => 'Test template',
    type    => 'individual',
    text    => <<'HTML',
<!doctype html>
<html><head><title>Individual test</title></head>
<body>
<p id="canonical_url"><mt:CanonicalURL></p>
<p id="canonical_link"><mt:CanonicalLink></p>
</body>
</html>
HTML
);
my $template2 = MT::Test::Permission->make_template(
    blog_id         => $blog->id,
    name            => 'Test template',
    type            => 'ct',
    content_type_id => $content_type->id,
    text            => <<'HTML',
<!doctype html>
<html><head><title>ContentType test</title></head>
<body>
<p id="canonical_url"><mt:CanonicalURL></p>
<p id="canonical_link"><mt:CanonicalLink></p>
</body>
</html>
HTML
);
my $template_map1_1 = MT::Test::Permission->make_templatemap(
    template_id   => $template1->id,
    blog_id       => $blog->id,
    archive_type  => 'Individual',
    file_template => 'another/entry/%y/%m/%f',
);
my $template_map1_2 = MT::Test::Permission->make_templatemap(
    template_id   => $template1->id,
    blog_id       => $blog->id,
    archive_type  => 'Individual',
    file_template => 'entry/%y/%m<$mt:SetVar name="slash" value="//"$><$mt:Var name="slash"$>%f',
    is_preferred  => 1,
);
my $template_map2_1 = MT::Test::Permission->make_templatemap(
    template_id   => $template2->id,
    blog_id       => $blog->id,
    archive_type  => 'ContentType',
    file_template => 'cd/%y/%m/%f',
    is_preferred  => 1,
);
my $template_map2_2 = MT::Test::Permission->make_templatemap(
    template_id   => $template2->id,
    blog_id       => $blog->id,
    archive_type  => 'ContentType',
    file_template => 'another/cd/%y/%m/%f',
);

MT->add_callback(
    'cms_pre_preview',
    1, undef,
    sub {
        my ($cb, $app, $obj, $data) = @_;
        if (my $class = ref($obj)) {
            my $ds = $class->datasource;
            my $data;
            $data = MT->model($ds)->load($obj->id);
            my $saved = $data->save;
            ok(
                $saved,
                "saving $class succeeded in cms_pre_preview callback"
            );
            warn $data->errstr unless $saved;
        }
    },
);

subtest 'entry' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->get_ok({
        __mode  => 'view',
        _type   => 'entry',
        blog_id => $blog->id,
        id      => $entry1->id,
    });
    my $form = $app->form;
    my $input = $form->find_input('__mode');
    $input->readonly(0);
    $input->value('preview_entry');
    $app->post_ok($form->click);
    $app->has_no_permission_error("preview_entry method succeeded");

    my ($preview) = grep /mt-preview/, $test_env->files;
    ok -f $preview, "preview ($preview) exists";
    my $html = do { open my $fh, '<', $preview; local $/; <$fh> };
    my $wq = Web::Query::LibXML->new($html);
    my $canon_url  = $wq->find('p#canonical_url')->text;
    my $canon_link = $wq->find('p#canonical_link')->html;
    is $canon_url => 'http://localhost/entry/2018/08/entry.html', "correct CanonincalURL";
    like $canon_link => qr{rel="canonical"}, "CanonicalLink has rel=canonical";
    like $canon_link => qr{href="http://localhost/entry/2018/08/entry.html"}, "CanonicalLink has correct URL";

    my $entry2 = MT->model('entry')->load($entry1->id);
    ok(
        $entry2->title eq 'entry',
        'original entry has not been changed (maybe cache)'
    );
    $entry2->refresh;
    ok(
        $entry2->title eq 'entry',
        'original entry has not been changed (not cache)'
    );
    unlink $preview;
};

subtest 'content_data' => sub {
    my $field_name = 'content-field-' . $cf_single->id;
    my $app        = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->get_ok({
        __mode          => 'view',
        _type           => 'content_data',
        blog_id         => $blog->id,
        content_type_id => $content_type->id,
        id              => $cd1->id,
    });
    my $form = $app->form;
    my $input = $form->find_input('__mode');
    $input->readonly(0);
    $input->value('preview_content_data');
    $app->post_ok($form->click);
    $app->has_no_permission_error("preview_content_data method succeeded");

    my ($preview) = grep /mt-preview/, $test_env->files;
    ok -f $preview, "preview ($preview) exists";
    my $html = do { open my $fh, '<', $preview; local $/; <$fh> };
    my $wq = Web::Query::LibXML->new($html);
    my $canon_url  = $wq->find('p#canonical_url')->text;
    my $canon_link = $wq->find('p#canonical_link')->html;
    is $canon_url => 'http://localhost/cd/2017/05/my content data.html', "correct CanonincalURL";
    like $canon_link => qr{rel="canonical"}, "CanonicalLink has rel=canonical";
    like $canon_link => qr{href="http://localhost/cd/2017/05/my content data.html"}, "CanonicalLink has correct URL";

    my $cd2 = MT->model('cd')->load($cd1->id);
    ok(
        $cd2->data->{ $cf_single->id } eq 'single line text',
        'original content_data has not been changed (maybe cache)'
    );
    $cd2->refresh;
    ok(
        $cd2->data->{ $cf_single->id } eq 'single line text',
        'original content_data has not been changed (not cache)'
    );
    unlink $preview;
};

subtest 'template' => sub {
    my $app = MT::Test::App->new('MT::App::CMS');
    $app->login($admin);
    $app->post_ok({
        __mode  => 'preview_template',
        blog_id => $blog->id,
        id      => $template1->id,
        name    => 'The rewritten name',
    });
    $app->has_no_permission_error("preview_template method succeeded");

    my $template2 = MT->model('template')->load($template1->id);
    ok(
        $template2->name eq 'Test template',
        'original template has not been changed (maybe cache)'
    );
    $template2->refresh;
    ok(
        $template2->name eq 'Test template',
        'original template has not been changed (not cache)'
    );
};

done_testing();
