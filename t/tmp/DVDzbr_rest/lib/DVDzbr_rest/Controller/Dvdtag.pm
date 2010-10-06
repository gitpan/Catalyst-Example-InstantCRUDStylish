use strict;
use warnings;

package DVDzbr_rest::Controller::Dvdtag;

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
    package DVDzbr_rest::Controller::Dvdtag::DvdtagForm;
    use HTML::FormHandler::Moose;
    extends 'HTML::FormHandler::Model::DBIC';
    with 'HTML::FormHandler::Render::Simple';


    has '+item_class' => ( default => 'Dvdtag' );

    has_field 'dvd' => ( type => 'Select', );
    has_field 'tag' => ( type => 'Select', );
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

sub base : Chained('/') PathPart('dvdtag') CaptureArgs(0) {}

1;

