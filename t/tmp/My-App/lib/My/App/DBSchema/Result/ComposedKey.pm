package My::App::DBSchema::Result::ComposedKey;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use base 'DBIx::Class::Core';

__PACKAGE__->load_components("InflateColumn::DateTime", "UTF8Columns");

=head1 NAME

My::App::DBSchema::Result::ComposedKey

=cut

__PACKAGE__->table("composed_key");

=head1 ACCESSORS

=head2 id1

  data_type: 'integer'
  is_nullable: 1

=head2 id2

  data_type: 'integer'
  is_nullable: 1

=head2 value

  data_type: 'varchar'
  is_nullable: 1
  size: 32

=cut

__PACKAGE__->add_columns(
  "id1",
  { data_type => "integer", is_nullable => 1 },
  "id2",
  { data_type => "integer", is_nullable => 1 },
  "value",
  { data_type => "varchar", is_nullable => 1, size => 32 },
);
__PACKAGE__->set_primary_key("id1", "id2");


# Created by DBIx::Class::Schema::Loader v0.06001 @ 2010-05-27 19:50:38
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:nWp2yCmi1xHenCGfBES+Cw


# You can replace this text with custom content, and it will be preserved on regeneration
use overload '""' => sub {$_[0]->id}, fallback => 1;
__PACKAGE__->utf8_columns(qw/id1 id2 value/);

1;