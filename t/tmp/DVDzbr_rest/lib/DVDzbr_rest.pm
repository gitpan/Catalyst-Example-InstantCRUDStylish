use strict;
use warnings;

package DVDzbr_rest;

use Catalyst::Runtime '5.70';
use Catalyst::Request::REST::ForBrowsers;

use Catalyst qw/
	-Debug
	ConfigLoader
	Static::Simple
    Unicode
/;
#	Session
#	Session::Store::FastMmap
#	Session::State::Cookie
#	Authentication
#	Authentication::Store::DBIC
#	Authentication::Credential::Password
#	Auth::Utils

our $VERSION = '0.01';

__PACKAGE__->config( name => 'DVDzbr_rest' );
__PACKAGE__->request_class( 'Catalyst::Request::REST::ForBrowsers' );

# Start the application
__PACKAGE__->setup;

#
# IMPORTANT: Please look into DVDzbr_rest::Controller::Root for more
#

=head1 NAME

DVDzbr_rest - Catalyst based application

=head1 SYNOPSIS

    script/dvdzbr_rest_server.pl

=head1 DESCRIPTION

Catalyst based application.

=head1 SEE ALSO

L<DVDzbr_rest::Controller::Root>, L<Catalyst>

=head1 AUTHOR

User &

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
