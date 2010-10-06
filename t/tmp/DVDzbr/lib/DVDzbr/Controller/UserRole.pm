use strict;
use warnings;

package DVDzbr::Controller::UserRole;

use base "Catalyst::Example::Controller::InstantCRUD";


{
    package DVDzbr::Controller::UserRole::UserRoleForm;
    use HTML::FormHandler::Moose;
    extends 'HTML::FormHandler::Model::DBIC';
    with 'HTML::FormHandler::Render::Simple';


    has '+item_class' => ( default => 'UserRole' );

    has_field 'user' => ( type => 'Select', );
    has_field 'role' => ( type => 'Select', );
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

sub base : Chained('/') PathPart('userrole') CaptureArgs(0) {}

1;

