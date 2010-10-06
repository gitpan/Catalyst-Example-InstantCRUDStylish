use strict;
use warnings;

package My::App::Controller::Secondtable;

use base "Catalyst::Example::Controller::InstantCRUD";


{
    package My::App::Controller::Secondtable::SecondtableForm;
    use HTML::FormHandler::Moose;
    extends 'HTML::FormHandler::Model::DBIC';
    with 'HTML::FormHandler::Render::Simple';


    has '+item_class' => ( default => 'Secondtable' );

    has_field 'charfield' => ( type => 'Text', size => 10, );
    has_field 'firstableid' => ( type => 'Select', );
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

sub base : Chained('/') PathPart('secondtable') CaptureArgs(0) {}

1;

