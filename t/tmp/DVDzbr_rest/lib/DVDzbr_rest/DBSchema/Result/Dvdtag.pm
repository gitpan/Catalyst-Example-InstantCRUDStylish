package DVDzbr_rest::DBSchema::Result::Dvdtag;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use base 'DBIx::Class::Core';

__PACKAGE__->load_components("InflateColumn::DateTime", "UTF8Columns");

=head1 NAME

DVDzbr_rest::DBSchema::Result::Dvdtag

=cut

__PACKAGE__->table("dvdtag");

=head1 ACCESSORS

=head2 dvd

  data_type: 'integer'
  default_value: 0
  is_foreign_key: 1
  is_nullable: 0

=head2 tag

  data_type: 'integer'
  default_value: 0
  is_foreign_key: 1
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "dvd",
  {
    data_type      => "integer",
    default_value  => 0,
    is_foreign_key => 1,
    is_nullable    => 0,
  },
  "tag",
  {
    data_type      => "integer",
    default_value  => 0,
    is_foreign_key => 1,
    is_nullable    => 0,
  },
);
__PACKAGE__->set_primary_key("dvd", "tag");

=head1 RELATIONS

=head2 tag

Type: belongs_to

Related object: L<DVDzbr_rest::DBSchema::Result::Tag>

=cut

__PACKAGE__->belongs_to(
  "tag",
  "DVDzbr_rest::DBSchema::Result::Tag",
  { id => "tag" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 dvd

Type: belongs_to

Related object: L<DVDzbr_rest::DBSchema::Result::Dvd>

=cut

__PACKAGE__->belongs_to(
  "dvd",
  "DVDzbr_rest::DBSchema::Result::Dvd",
  { id => "dvd" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);


# Created by DBIx::Class::Schema::Loader v0.06001 @ 2010-05-27 19:50:51
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:sbWvdzsBXIQEp5NMYeUzFw


# You can replace this text with custom content, and it will be preserved on regeneration
use overload '""' => sub {$_[0]->id}, fallback => 1;
__PACKAGE__->utf8_columns(qw/dvd tag/);

1;