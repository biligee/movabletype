package MT::ContentFieldType::DateTime;
use strict;
use warnings;

use MT;
use MT::App::CMS;
use MT::ContentField;
use MT::ContentFieldType::Common qw( get_cd_ids_by_left_join );
use MT::Util ();

sub html {
    my $prop = shift;
    my ( $obj, $app, $opts ) = @_;
    my $ts = $obj->data->{ $prop->{content_field_id} } or return '';

    # TODO: implement date_format option to content field.
    my $content_field = MT::ContentField->load( $prop->{content_field_id} )
        or return '';
    my $date_format = eval { $content_field->options->{date_format} }
        || MT::App::CMS::LISTING_TIMESTAMP_FORMAT();

    my $blog = $opts->{blog};
    return MT::Util::format_ts( $date_format, $ts, $blog,
          $app->user
        ? $app->user->preferred_language
        : undef );
}

sub terms {
    my $prop = shift;
    my ( $args, $db_terms, $db_args ) = @_;

    my $join_terms = $prop->super(@_);
    my $cd_ids = get_cd_ids_by_left_join( $prop, $join_terms, undef, @_ );
    { id => $cd_ids };
}

sub field_html_params {
    my ( $app, $field_data ) = @_;
    my $value = $field_data->{value} || '';

    # for initial_value.
    $value = '' unless defined $value;
    $value =~ s/[ \-:]//g;

    my $date = '';
    my $time = '';
    if ( defined $value && $value ne '' ) {
        $date = MT::Util::format_ts( "%Y-%m-%d", $value, $app->blog,
            $app->user ? $app->user->preferred_language : undef );
        $time = MT::Util::format_ts( "%H:%M:%S", $value, $app->blog,
            $app->user ? $app->user->preferred_language : undef );
    }

    my $required = $field_data->{options}{required} ? 'required' : '';

    {   date     => $date,
        time     => $time,
        required => $required,
    };
}

sub field_html {
    my ( $app, $id, $value ) = @_;

    # for initial_value.
    $value = '' unless defined $value;
    $value =~ s/[ \-:]//g;

    my $date = '';
    my $time = '';
    if ( defined $value && $value ne '' ) {
        $date = MT::Util::format_ts( "%Y-%m-%d", $value, $app->blog,
            $app->user ? $app->user->preferred_language : undef );
        $time = MT::Util::format_ts( "%H:%M:%S", $value, $app->blog,
            $app->user ? $app->user->preferred_language : undef );
    }

    my $content_field = MT::ContentField->load($id);
    my $required = $content_field->options->{required} ? 'required' : '';

    my $date_error = $app->translate('Invalid date.');
    my $time_error = $app->translate('Invalid time..');

    my $html = '';
    $html .= '<span>';
    $html
        .= "<input type=\"text\" name=\"date-$id\" id=\"date-$id\" class=\"text date text-date\" value=\"$date\" placeholder=\"YYYY-MM-DD\" mt:watch-change=\"1\" mt:raw-name=\"1\" $required />";
    $html .= '</span> ';
    $html .= '<span class="separator"> <__trans phrase="@"></span> ';
    $html .= '<span>';
    $html
        .= "<input type=\"text\" name=\"time-$id\" id=\"time-$id\" class=\"text time\" value=\"$time\" placeholder=\"HH:mm:ss\" mt:watch-change=\"1\" mt:raw-name=\"1\" $required />";
    $html .= '</span> ';

    $html .= <<"__JS__";
<script>
(function () {
  var date = jQuery('input[name=date-${id}]').get(0);
  var time = jQuery('input[name=time-${id}]').get(0);

  function validateDate () {
    if (jQuery.mtValidateRules['.date'](jQuery(date))) {
      date.setCustomValidity('');
    } else {
      date.setCustomValidity('${date_error}');
    }
  }

  function validateTime () {
    var \$e = jQuery(time);
    if (!\$e.val() || /^\\d{2}:\\d{2}:\\d{2}\$/.test(\$e.val())) {
      time.setCustomValidity('');
    } else {
      time.setCustomValidity('${time_error}');
    }
  }

  jQuery(date).on('change', validateDate);
  jQuery(time).on('change', validateTime);

  validateDate();
  validateTime();
})();
</script>
__JS__

    return $html;
}

sub data_getter {
    my ( $app, $id ) = @_;
    my $q    = $app->param;
    my $date = $q->param( 'date-' . $id );
    my $time = $q->param( 'time-' . $id );
    my $ts   = $date . $time;
    $ts =~ s/\D//g;
    return $ts;
}

sub ss_validator {
    my ( $app, $field_data ) = @_;
    my $id   = $field_data->{id};
    my $q    = $app->param;
    my $date = $q->param( 'date-' . $id );
    my $time = $q->param( 'time-' . $id );
    my $ts   = $date . $time;
    unless ( !defined $ts || $ts eq '' || MT::Util::is_valid_date($ts) ) {
        return $app->translate( "Invalid date and time: '[_1] [_2]'",
            $date, $time );
    }
    undef;
}

1;

