# Movable Type (r) Open Source (C) 2001-2013 Six Apart, Ltd.
# This program is distributed under the terms of the
# GNU General Public License, version 2.
#
# $Id$
package MT::DataAPI::Endpoint::Blog;

use warnings;
use strict;

use MT::DataAPI::Endpoint::Common;

sub list {
    my ( $app, $endpoint ) = @_;

    # TODO if user_id ne "me"
    my $res = filtered_list( $app, $endpoint, 'blog', { class => '*' } );

    +{  totalResults => $res->{count},
        items        => $res->{objects},
    };
}

1;
