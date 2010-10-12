use Test::More tests => 3;

BEGIN {
use_ok( 'Catalyst::Example::Controller::InstantCRUDStylish' );
use_ok( 'Catalyst::Helper::Controller::InstantCRUDStylish' );
use_ok( 'Catalyst::Example::InstantCRUDStylish');
}

diag( "Testing Catalyst::Example::InstantCRUDStylish $Catalyst::Example::InstantCRUDStylish::VERSION" );
