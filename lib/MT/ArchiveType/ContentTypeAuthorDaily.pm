# Movable Type (r) (C) 2001-2017 Six Apart, Ltd. All Rights Reserved.
# This code cannot be redistributed without permission from www.sixapart.com.
# For more information, consult your Movable Type license.
#
# $Id$

package MT::ArchiveType::ContentTypeAuthorDaily;

use strict;
use base
    qw( MT::ArchiveType::ContentTypeAuthor MT::ArchiveType::ContentTypeDaily MT::ArchiveType::AuthorDaily );

use MT::Util qw( dirify start_end_day );

sub name {
    return 'ContentType-Author-Daily';
}

sub archive_label {
    return MT->translate("CONTENTTYPE-AUTHOR-DAILY_ADV");
}

sub default_archive_templates {
    return [
        {   label           => 'author/author-basename/yyyy/mm/dd/index.html',
            template        => 'author/%-a/%y/%m/%d/%f',
            default         => 1,
            required_fields => { date_and_time => 1 }
        },
        {   label           => 'author/author_basename/yyyy/mm/dd/index.html',
            template        => 'author/%a/%y/%m/%d/%f',
            required_fields => { date_and_time => 1 }
        },
    ];
}

sub template_params {
    return { archive_class => "contenttype-author-daily-archive" };
}

*date_range    = \&MT::ArchiveType::Daily::date_range;
*archive_file  = \&MT::ArchiveType::AuthorDaily::archive_file;
*archive_title = \&MT::ArchiveType::AuthorDaily::archive_title;

1;
