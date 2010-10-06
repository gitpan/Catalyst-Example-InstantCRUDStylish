use strict;
use warnings;

package DVDzbr::Controller::UnicodeExample;

use base "Catalyst::Example::Controller::InstantCRUD";


{
    package DVDzbr::Controller::UnicodeExample::UnicodeExampleForm;
    use HTML::FormHandler::Moose;
    extends 'HTML::FormHandler::Model::DBIC';
    with 'HTML::FormHandler::Render::Simple';


    has '+item_class' => ( default => 'UnicodeExample' );

    has_field 'example_text' => ( type => 'TextArea', );
    has_field 'main_unicode_set' => ( type => 'TextArea', );
    has_field 'language_name' => ( type => 'TextArea', );
    has_field 'iso_country_code' => ( type => 'Text', size => 2, );
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

sub base : Chained('/') PathPart('unicodeexample') CaptureArgs(0) {}

1;

