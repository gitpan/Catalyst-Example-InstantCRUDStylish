use strict;
use warnings;
use Test::More; 
use String::Random qw(random_string random_regex);
use DBI;

BEGIN {
use lib 't/tmp/My-App/lib';
}

eval "use Test::WWW::Mechanize::Catalyst 'My::App'";
if ($@){
    plan skip_all => "Test::WWW::Mechanize::Catalyst required for testing application";
}else{
    plan tests => 27;
}

my $mech = Test::WWW::Mechanize::Catalyst->new;
$mech->get_ok("http://localhost/", "Application Running");

#$mech->follow_link_ok({ text => "Home" }, "Click on Usr");
#$mech->get_ok('/usr');

my @links = $mech->find_all_links( url_regex => qr/Usr ComposedKey Bookmark Firsttable Secondtable/i );
$mech->links_ok( \@links, 'Check all links for Usr' );

$mech->follow_link_ok({ text_regex => qr/Firsttable/ }, "Click on Firsttable");

$mech->follow_link_ok({text => 'Intfield'}, "sort by intfield");
$mech->content_contains("This is the row with the smallest int", "smallest int row found");

$mech->follow_link_ok({text => 'Intfield'}, "desc sort by intfield");
$mech->content_contains("This is the row with the biggest int", "biggest int row found");

$mech->follow_link_ok({text => '3'}, "desc sort by intfield page 3");
$mech->content_contains("This is the row with the smallest int", "smallest int row found");
#10
   $mech->get_ok("/firsttable/edit/2", "Edit fisttable 2nd record");
   $mech->submit_form(
       form_number => 1,
       fields      => {
           intfield => '3',
           varfield => 'Changed varchar field',
           charfield => 'a',
       }
   );
#12   
   $mech->get_ok("/firsttable/edit_ajax/2", "Edit_ajax fisttable 2nd record");
   $mech->submit_form(
       form_number => 1,
       fields      => {
           intfield => '3',
           varfield => 'Changed varchar field with edit_ajax',
           charfield => 'a',
       }
   );
$mech->get_ok("http://localhost/", "Application Running");

#13
$mech->follow_link_ok({ text_regex => qr/Firsttable/ }, "Click on Firsttable");

$mech->content_contains("Changed varchar field with edit_ajax", "Record changed");
$mech->get_ok("/firsttable/destroy/2", "Destroy 2nd record");
$mech->submit_form( form_number => 1 );
$mech->content_contains("Deleted!", "Record changed");
$mech->get_ok("/firsttable", "go back to firsttable listings");
$mech->content_lacks("Changed varchar field", "Record deleted");

$mech->follow_link_ok( {text_regex => qr/ComposedKey/ } , "Click on composed key table");

$mech->follow_link_ok({ text_regex => qr/New/}, "Click on composed key Add row");
my $id1 = int(rand(1000000));
my $id2 = int(rand(1000000));
$mech->submit_form(
    form_number => 2,
    fields      => {
        id1 => $id1,
        id2 => $id2,
        value => 'Varchar Field',
    }
);
$mech->content_like( "/>$id1</", 'Viewing record with composed key' );
$mech->get_ok( "/composedkey/edit/$id1/$id2" , "Editing a record with composed key"); #TODO :replace for a follow_link
$mech->content_contains( $id1, 'Following Edit for a record with composed key' );
my $random_string = 'random ' . random_regex('\w{20}');
#DBI->trace(1);
$mech->submit_form(
    form_number => 2,
    fields      => {
        value => $random_string,
    }
);
$mech->content_contains( $id1, 'Editing record with composed key' );
$mech->content_contains( $random_string, 'Editing record with composed key' );
$mech->follow_link_ok({text_regex => qr/list/}, "Listing records with composed key");
$mech->content_contains( $random_string, 'Listing of records with composed key contains the new record' );

