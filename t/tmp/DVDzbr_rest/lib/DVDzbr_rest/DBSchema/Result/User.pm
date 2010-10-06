package DVDzbr_rest::DBSchema::Result::User;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use base 'DBIx::Class::Core';

__PACKAGE__->load_components("InflateColumn::DateTime", "UTF8Columns");

=head1 NAME

DVDzbr_rest::DBSchema::Result::User

=cut

__PACKAGE__->table("user");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 username

  data_type: 'varchar'
  default_value: NULL
  is_nullable: 1
  size: 255

=head2 password

  data_type: 'varchar'
  default_value: NULL
  is_nullable: 1
  size: 255

=head2 name

  data_type: 'varchar'
  default_value: NULL
  is_nullable: 1
  size: 255

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "username",
  {
    data_type => "varchar",
    default_value => \"NULL",
    is_nullable => 1,
    size => 255,
  },
  "password",
  {
    data_type => "varchar",
    default_value => \"NULL",
    is_nullable => 1,
    size => 255,
  },
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

=head2 dvd_current_borrowers

Type: has_many

Related object: L<DVDzbr_rest::DBSchema::Result::Dvd>

=cut

__PACKAGE__->has_many(
  "dvd_current_borrowers",
  "DVDzbr_rest::DBSchema::Result::Dvd",
  { "foreign.current_borrower" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 dvd_owners

Type: has_many

Related object: L<DVDzbr_rest::DBSchema::Result::Dvd>

=cut

__PACKAGE__->has_many(
  "dvd_owners",
  "DVDzbr_rest::DBSchema::Result::Dvd",
  { "foreign.owner" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 user_roles

Type: has_many

Related object: L<DVDzbr_rest::DBSchema::Result::UserRole>

=cut

__PACKAGE__->has_many(
  "user_roles",
  "DVDzbr_rest::DBSchema::Result::UserRole",
  { "foreign.user" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.06001 @ 2010-05-27 19:50:51
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:pqD3cl4pnqvxOatkFKOBaw


# You can replace this text with custom content, and it will be preserved on regeneration
use overload '""' => sub {$_[0]->username}, fallback => 1;
__PACKAGE__->many_to_many('roles', 'user_roles' => 'role');
__PACKAGE__->utf8_columns(qw/id username password name/);

1;