use strict;
use warnings;

package My::App::Controller::Firsttable;

use base "Catalyst::Example::Controller::InstantCRUD";


{
    package My::App::Controller::Firsttable::FirsttableForm;
    use HTML::FormHandler::Moose;
    extends 'HTML::FormHandler::Model::DBIC';
    with 'HTML::FormHandler::Render::Simple';


    has '+item_class' => ( default => 'Firsttable' );

    has_field 'varfield' => ( type => 'TextArea', );
    has_field 'charfield' => ( type => 'Text', size => 10, );
    has_field 'intfield' => ( type => 'Integer', );
    # has_field 'secondtables' => ( type => '+My::App::Controller::Firsttable::SecondtableField', );
    has_field 'submit' => ( widget => 'submit' )
}


{
    package My::App::Controller::Firsttable::SecondtableField;
    use HTML::FormHandler::Moose;
    extends 'HTML::FormHandler::Field::Compound';

        has_field 'charfield' => ( type => 'Text', size => 10, );
        has_field 'firstableid' => ( type => 'Select', );
    
}




__PACKAGE__->config(
    action => {
        list => { Chained => 'base', PathPart => q{}, Args => 0 },
        view => { Chained => 'base' },
        edit => { Chained => 'base' },
        destroy => { Chained => 'base' },
    },
);

sub base : Chained('/') PathPart('firsttable') CaptureArgs(0) {}

1;

