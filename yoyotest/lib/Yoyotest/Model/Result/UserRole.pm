use utf8;
package Yoyotest::Model::Result::UserRole;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Yoyotest::Model::Result::UserRole - A pivot table

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 COMPONENTS LOADED

=over 4

=item * L<DBIx::Class::InflateColumn::DateTime>

=back

=cut

__PACKAGE__->load_components("InflateColumn::DateTime");

=head1 TABLE: C<user_roles>

=cut

__PACKAGE__->table("user_roles");

=head1 ACCESSORS

=head2 user_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 0

=head2 role_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "user_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 0,
  },
  "role_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 0,
  },
);

=head1 PRIMARY KEY

=over 4

=item * L</role_id>

=item * L</user_id>

=back

=cut

__PACKAGE__->set_primary_key("role_id", "user_id");

=head1 RELATIONS

=head2 role

Type: belongs_to

Related object: L<Yoyotest::Model::Result::Role>

=cut

__PACKAGE__->belongs_to(
  "role",
  "Yoyotest::Model::Result::Role",
  { id => "role_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 user

Type: belongs_to

Related object: L<Yoyotest::Model::Result::User>

=cut

__PACKAGE__->belongs_to(
  "user",
  "Yoyotest::Model::Result::User",
  { id => "user_id" },
  { is_deferrable => 1, on_delete => "NO ACTION", on_update => "NO ACTION" },
);


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-04-18 21:05:59
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:WsU8Slw2vq97+3jEgRqubg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
