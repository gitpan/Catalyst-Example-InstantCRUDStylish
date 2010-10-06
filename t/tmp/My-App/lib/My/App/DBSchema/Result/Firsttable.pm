package My::App::DBSchema::Result::Firsttable;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use base 'DBIx::Class::Core';

__PACKAGE__->load_components("InflateColumn::DateTime", "UTF8Columns");

=head1 NAME

My::App::DBSchema::Result::Firsttable

=cut

__PACKAGE__->table("firsttable");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_nullable: 1

=head2 intfield

  data_type: 'integer'
  is_nullable: 1

=head2 charfield

  data_type: 'char'
  is_nullable: 1
  size: 10

=head2 varfield

  data_type: 'varchar'
  is_nullable: 1
  size: 100

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_nullable => 1 },
  "intfield",
  { data_type => "integer", is_nullable => 1 },
  "charfield",
  { data_type => "char", is_nullable => 1, size => 10 },
  "varfield",
  { data_type => "varchar", is_nullable => 1, size => 100 },
);
__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 secondtables

Type: has_many

Related object: L<My::App::DBSchema::Result::Secondtable>

=cut

__PACKAGE__->has_many(
  "secondtables",
  "My::App::DBSchema::Result::Secondtable",
  { "foreign.firstableid" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.06001 @ 2010-05-27 19:50:38
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:tU32hV4o37Xwi7M3V/eohg


# You can replace this text with custom content, and it will be preserved on regeneration
use overload '""' => sub {$_[0]->id}, fallback => 1;
__PACKAGE__->utf8_columns(qw/id intfield charfield varfield/);

1;