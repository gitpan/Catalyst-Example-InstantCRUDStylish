package DVDzbr_rest::DBSchema::Result::UnicodeExample;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use base 'DBIx::Class::Core';

__PACKAGE__->load_components("InflateColumn::DateTime", "UTF8Columns");

=head1 NAME

DVDzbr_rest::DBSchema::Result::UnicodeExample

=cut

__PACKAGE__->table("unicode_examples");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 iso_country_code

  data_type: 'char'
  is_nullable: 1
  size: 2

=head2 language_name

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 main_unicode_set

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 example_text

  data_type: 'text'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "iso_country_code",
  { data_type => "char", is_nullable => 1, size => 2 },
  "language_name",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "main_unicode_set",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "example_text",
  { data_type => "text", is_nullable => 1 },
);
__PACKAGE__->set_primary_key("id");


# Created by DBIx::Class::Schema::Loader v0.06001 @ 2010-05-27 19:50:51
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:C+o6vQl71UsmtzL4oNdA7w


# You can replace this text with custom content, and it will be preserved on regeneration
use overload '""' => sub {$_[0]->language_name}, fallback => 1;
__PACKAGE__->utf8_columns(qw/id iso_country_code language_name main_unicode_set example_text/);

1;