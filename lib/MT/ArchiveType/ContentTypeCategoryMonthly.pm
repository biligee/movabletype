# Movable Type (r) (C) 2001-2017 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::ArchiveType::ContentTypeCategoryMonthly;

use strict;
use base qw( MT::ArchiveType::ContentTypeCategory MT::ArchiveType::ContentTypeMonthly );

use MT::Util qw( remove_html encode_html );

sub name {
    return 'ContentType-Category-Monthly';
}

sub archive_label {
    return MT->translate("CONTENTTYPE-CATEGORY-MONTHLY_ADV");
}

sub template_params {
    return {
        archive_class => "contenttype-category-monthly-archive",
    };
}

sub archive_file {
    my $obj = shift;
    my ( $ctx, %param ) = @_;
}

sub archive_title {
}

1;


