#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../../lib";    # t/lib
use Test::More;
use MT::Test::Env;
our $test_env;

BEGIN {
    $test_env = MT::Test::Env->new(
        DefaultLanguage => 'en_US',    ## for now
    );
    $ENV{MT_CONFIG} = $test_env->config_file;
}

use MT::Test::Tag;

plan tests => (1 + 2) * blocks;

use MT;
use MT::Test;
use MT::Test::Permission;
use MT::Test::Fixture;
use MT::Test::Fixture::ContentData;

my $app = MT->instance;

my $vars = {};

sub var {
    for my $line (@_) {
        for my $key (keys %{$vars}) {
            my $replace = quotemeta "[% ${key} %]";
            my $value   = $vars->{$key};
            $line =~ s/$replace/$value/g;
        }
    }
    @_;
}

filters {
    template       => [qw( var chomp )],
    expected       => [qw( var chomp )],
    expected_error => [qw( chomp )],
};

$test_env->prepare_fixture('content_data');

my $blog    = MT->model('blog')->load({ name => 'My Site' });
my $blog_id = $blog->id;
my $author  = MT->model('author')->load({ name => 'Melody' });

my $entry = MT->model('entry')->new(
    blog_id        => $blog->id,
    author_id      => $author->id,
    status         => MT->model('entry')->RELEASE(),
    title          => 'Test Entry',
    convert_breaks => 'block_editor',
);
$entry->save or die $entry->errstr;

MT::Test::Tag->run_perl_tests($blog_id);
MT::Test::Tag->run_php_tests($blog_id);

__END__

=== mt:TextFormat for a content field
--- template
<mt:Contents content_type="test content data">
<mt:ContentField content_field="multi line text"><mt:TextFormat></mt:ContentField>
</mt:Contents>
--- expected
__default__

=== mt:TextFormat for an entry
--- template
<mt:Entries>
<mt:TextFormat>
</mt:Entries>
--- expected
block_editor

=== mt:TextFormat in top level context
--- template
<mt:TextFormat>
--- expected_error
You used an 'mtTextFormat' tag outside of the context of the correct content;

=== mt:TextFormat for a single line text filed context
--- template
<mt:Contents content_type="test content data">
<mt:ContentField content_field="single line text"><mt:TextFormat></mt:ContentField>
</mt:Contents>
--- expected_error
Error in <mtContentField> tag: You used an 'mtTextFormat' tag outside of the context of an 'Multi Line Text' field.
--- expected_php_error
You used an 'mtTextFormat' tag outside of the context of an 'Multi Line Text' field.
