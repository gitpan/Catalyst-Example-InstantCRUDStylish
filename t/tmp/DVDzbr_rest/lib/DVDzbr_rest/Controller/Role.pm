use strict;
use warnings;

package DVDzbr_rest::Controller::Role;

use base "Catalyst::Example::Controller::InstantCRUD::REST";
__PACKAGE__->config(
    serialize => {
        default => 'text/html',
        map => {
            'text/html'   => [ 'View', 'TT' ],
            'text/x-json' => 'JSON::Syck',
        }
    }
);


{
    package DVDzbr_rest::Controller::Role::RoleForm;
    use HTML::FormHandler::Moose;
    extends 'HTML::FormHandler::Model::DBIC';
    with 'HTML::FormHandler::Render::Simple';


    has '+item_class' => ( default => 'Role' );

    has_field 'users' => ( type => 'Select', multiple => 1 );
    has_field 'role' => ( type => 'TextArea', );
    has_field 'submit' => ( widget => 'submit' )
}




__PACKAGE__->config(
    action => {
        list => { Chained => 'base', PathPart => q{}, Args => 0 },
        view => { Chained => 'base' },
        edit => { Chained => 'base' },
        destroy => { Chained => 'base' },
    },
);

sub base : Chained('/') PathPart('role') CaptureArgs(0) {}

1;

