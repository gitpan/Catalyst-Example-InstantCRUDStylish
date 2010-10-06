use strict;
use warnings;

package My::App::Controller::ComposedKey;

use base "Catalyst::Example::Controller::InstantCRUD";


{
    package My::App::Controller::ComposedKey::ComposedKeyForm;
    use HTML::FormHandler::Moose;
    extends 'HTML::FormHandler::Model::DBIC';
    with 'HTML::FormHandler::Render::Simple';


    has '+item_class' => ( default => 'ComposedKey' );

    has_field 'value' => ( type => 'Text', size => 32, );
    has_field 'id2' => ( type => 'Integer', );
    has_field 'id1' => ( type => 'Integer', );
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

sub base : Chained('/') PathPart('composedkey') CaptureArgs(0) {}

1;

