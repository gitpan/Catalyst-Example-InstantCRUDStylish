package DVDzbr_rest::DBSchema::Result::Dvd;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use base 'DBIx::Class::Core';

__PACKAGE__->load_components("InflateColumn::DateTime", "UTF8Columns");

=head1 NAME

DVDzbr_rest::DBSchema::Result::Dvd

=cut

__PACKAGE__->table("dvd");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 name

  data_type: 'varchar'
  default_value: NULL
  is_nullable: 1
  size: 255

=head2 imdb_id

  data_type: 'integer'
  default_value: NULL
  is_nullable: 1

=head2 owner

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 current_borrower

  data_type: 'integer'
  default_value: NULL
  is_foreign_key: 1
  is_nullable: 1

=head2 creation_date

  data_type: 'date'
  default_value: NULL
  is_nullable: 1

=head2 alter_date

  data_type: 'datetime'
  default_value: NULL
  is_nullable: 1

=head2 hour

  data_type: 'time'
  default_value: NULL
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "name",
  {
    data_type => "varchar",
    default_value => \"NULL",
    is_nullable => 1,
    size => 255,
  },
  "imdb_id",
  { data_type => "integer", default_value => \"NULL", is_nullable => 1 },
  "owner",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "current_borrower",
  {
    data_type      => "integer",
    default_value  => \"NULL",
    is_foreign_key => 1,
    is_nullable    => 1,
  },
  "creation_date",
  { data_type => "date", default_value => \"NULL", is_nullable => 1 },
  "alter_date",
  { data_type => "datetime", default_value => \"NULL", is_nullable => 1 },
  "hour",
  { data_type => "time", default_value => \"NULL", is_nullable => 1 },
);
__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 current_borrower

Type: belongs_to

Related object: L<DVDzbr_rest::DBSchema::Result::User>

=cut

__PACKAGE__->belongs_to(
  "current_borrower",
  "DVDzbr_rest::DBSchema::Result::User",
  { id => "current_borrower" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "CASCADE",
    on_update     => "CASCADE",
  },
);

=head2 owner

Type: belongs_to

Related object: L<DVDzbr_rest::DBSchema::Result::User>

=cut

__PACKAGE__->belongs_to(
  "owner",
  "DVDzbr_rest::DBSchema::Result::User",
  { id => "owner" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 dvdtags

Type: has_many

Related object: L<DVDzbr_rest::DBSchema::Result::Dvdtag>

=cut

__PACKAGE__->has_many(
  "dvdtags",
  "DVDzbr_rest::DBSchema::Result::Dvdtag",
  { "foreign.dvd" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.06001 @ 2010-05-27 19:50:51
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:NNCoL/vwcpK2U/X1W68yUg


# You can replace this text with custom content, and it will be preserved on regeneration
use overload '""' => sub {$_[0]->name}, fallback => 1;
__PACKAGE__->many_to_many('tags', 'dvdtags' => 'tag');
__PACKAGE__->utf8_columns(qw/id name imdb_id owner current_borrower creation_date alter_date hour/);

1;