package DVDzbr::DBSchema::Result::Tag;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use base 'DBIx::Class::Core';

__PACKAGE__->load_components("InflateColumn::DateTime", "UTF8Columns");

=head1 NAME

DVDzbr::DBSchema::Result::Tag

=cut

__PACKAGE__->table("tag");

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
);
__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 dvdtags

Type: has_many

Related object: L<DVDzbr::DBSchema::Result::Dvdtag>

=cut

__PACKAGE__->has_many(
  "dvdtags",
  "DVDzbr::DBSchema::Result::Dvdtag",
  { "foreign.tag" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.06001 @ 2010-05-27 19:50:46
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:SBYfGFilv1BzS6psyv24Zg


# You can replace this text with custom content, and it will be preserved on regeneration
use overload '""' => sub {$_[0]->name}, fallback => 1;
__PACKAGE__->many_to_many('dvds', 'dvdtags' => 'dvd');
__PACKAGE__->utf8_columns(qw/id name/);

1;