package My::App::DBSchema::Result::Bookmark;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use base 'DBIx::Class::Core';

__PACKAGE__->load_components("InflateColumn::DateTime", "UTF8Columns");

=head1 NAME

My::App::DBSchema::Result::Bookmark

=cut

__PACKAGE__->table("bookmark");

=head1 ACCESSORS

=head2 id

  data_type: 'serial'
  is_nullable: 1

=head2 usr

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "serial", is_nullable => 1 },
  "usr",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
);
__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 usr

Type: belongs_to

Related object: L<My::App::DBSchema::Result::Usr>

=cut

__PACKAGE__->belongs_to(
  "usr",
  "My::App::DBSchema::Result::Usr",
  { id => "usr" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "CASCADE",
    on_update     => "CASCADE",
  },
);


# Created by DBIx::Class::Schema::Loader v0.06001 @ 2010-05-27 19:50:38
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:4JXMDuUyLhD//atdVHU5qw


# You can replace this text with custom content, and it will be preserved on regeneration
use overload '""' => sub {$_[0]->id}, fallback => 1;
__PACKAGE__->utf8_columns(qw/id usr/);

1;