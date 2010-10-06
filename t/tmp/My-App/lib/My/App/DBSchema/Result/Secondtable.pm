package My::App::DBSchema::Result::Secondtable;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use base 'DBIx::Class::Core';

__PACKAGE__->load_components("InflateColumn::DateTime", "UTF8Columns");

=head1 NAME

My::App::DBSchema::Result::Secondtable

=cut

__PACKAGE__->table("secondtable");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_nullable: 1

=head2 firstableid

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

=head2 charfield

  data_type: 'char'
  is_nullable: 1
  size: 10

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_nullable => 1 },
  "firstableid",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
  "charfield",
  { data_type => "char", is_nullable => 1, size => 10 },
);
__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 firstableid

Type: belongs_to

Related object: L<My::App::DBSchema::Result::Firsttable>

=cut

__PACKAGE__->belongs_to(
  "firstableid",
  "My::App::DBSchema::Result::Firsttable",
  { id => "firstableid" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "CASCADE",
    on_update     => "CASCADE",
  },
);


# Created by DBIx::Class::Schema::Loader v0.06001 @ 2010-05-27 19:50:38
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:dIhLmUVQwqf9rxnAPZWn1A


# You can replace this text with custom content, and it will be preserved on regeneration
use overload '""' => sub {$_[0]->id}, fallback => 1;
__PACKAGE__->utf8_columns(qw/id firstableid charfield/);

1;