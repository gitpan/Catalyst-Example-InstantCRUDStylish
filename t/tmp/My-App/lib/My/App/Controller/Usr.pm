use strict;
use warnings;

package My::App::Controller::Usr;

use base "Catalyst::Example::Controller::InstantCRUD";


{
    package My::App::Controller::Usr::UsrForm;
    use HTML::FormHandler::Moose;
    extends 'HTML::FormHandler::Model::DBIC';
    with 'HTML::FormHandler::Render::Simple';


    has '+item_class' => ( default => 'Usr' );

    # has_field 'bookmarks' => ( type => '+My::App::Controller::Usr::BookmarkField', );
    has_field 'submit' => ( widget => 'submit' )
}


{
    package My::App::Controller::Usr::BookmarkField;
    use HTML::FormHandler::Moose;
    extends 'HTML::FormHandler::Field::Compound';

        has_field 'usr' => ( type => 'Select', );
    
}




__PACKAGE__->config(
    action => {
        list => { Chained => 'base', PathPart => q{}, Args => 0 },
        view => { Chained => 'base' },
        edit => { Chained => 'base' },
        destroy => { Chained => 'base' },
    },
);

sub base : Chained('/') PathPart('usr') CaptureArgs(0) {}

1;

