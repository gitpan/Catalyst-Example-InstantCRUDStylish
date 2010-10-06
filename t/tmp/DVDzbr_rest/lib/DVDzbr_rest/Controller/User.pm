use strict;
use warnings;

package DVDzbr_rest::Controller::User;

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
    package DVDzbr_rest::Controller::User::UserForm;
    use HTML::FormHandler::Moose;
    extends 'HTML::FormHandler::Model::DBIC';
    with 'HTML::FormHandler::Render::Simple';

    use DateTime;


    has '+item_class' => ( default => 'User' );

    has_field 'roles' => ( type => 'Select', multiple => 1 );
    has_field 'name' => ( type => 'TextArea', );
    has_field 'password' => ( type => 'TextArea', );
    has_field 'username' => ( type => 'TextArea', );
    # has_field 'dvd_owners' => ( type => '+DVDzbr_rest::Controller::User::DvdField', );
    # has_field 'dvd_current_borrowers' => ( type => '+DVDzbr_rest::Controller::User::DvdField', );
    has_field 'submit' => ( widget => 'submit' )
}


{
    package DVDzbr_rest::Controller::User::DvdField;
    use HTML::FormHandler::Moose;
    extends 'HTML::FormHandler::Field::Compound';

        has_field 'tags' => ( type => 'Select', multiple => 1 );
        has_field 'hour' => ( type => 'Text', );
        has_field 'alter_date' => ( 
            type => 'Compound',
            apply => [
                {
                    transform => sub{ DateTime->new( $_[0] ) },
                    message => "Not a valid DateTime",
                }
            ],
        );
        has_field 'alter_date.year';        has_field 'alter_date.month';        has_field 'alter_date.day';
        has_field 'creation_date' => ( 
            type => 'Compound',
            apply => [
                {
                    transform => sub{ DateTime->new( $_[0] ) },
                    message => "Not a valid DateTime",
                }
            ],
        );
        has_field 'creation_date.year';        has_field 'creation_date.month';        has_field 'creation_date.day';
        has_field 'imdb_id' => ( type => 'Integer', );
        has_field 'name' => ( type => 'TextArea', );
        has_field 'owner' => ( type => 'Select', );
        has_field 'current_borrower' => ( type => 'Select', );
    
}




__PACKAGE__->config(
    action => {
        list => { Chained => 'base', PathPart => q{}, Args => 0 },
        view => { Chained => 'base' },
        edit => { Chained => 'base' },
        destroy => { Chained => 'base' },
    },
);

sub base : Chained('/') PathPart('user') CaptureArgs(0) {}

1;

