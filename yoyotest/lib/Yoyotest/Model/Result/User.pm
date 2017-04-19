use utf8;
package Yoyotest::Model::Result::User;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Yoyotest::Model::Result::User

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';
use DBIx::Class::TimeStamp;

=head1 COMPONENTS LOADED

=over 4

=item * L<DBIx::Class::InflateColumn::DateTime>

=back

=cut

__PACKAGE__->load_components("InflateColumn::DateTime");

=head1 TABLE: C<users>

=cut

__PACKAGE__->table("users");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 username

  data_type: 'varchar'
  is_nullable: 0
  size: 20

=head2 password

  data_type: 'varchar'
  is_nullable: 0
  size: 45

=head2 email

  data_type: 'varchar'
  is_nullable: 1
  size: 45

=head2 first_name

  data_type: 'varchar'
  is_nullable: 1
  size: 35

=head2 last_name

  data_type: 'varchar'
  is_nullable: 1
  size: 35

=head2 created_at

  data_type: 'datetime'
  datetime_undef_if_invalid: 1
  default_value: 'CURRENT_TIMESTAMP'
  is_nullable: 1

=head2 updated_at

  data_type: 'datetime'
  datetime_undef_if_invalid: 1
  default_value: 'CURRENT_TIMESTAMP'
  is_nullable: 1

=head2 is_deleted

  data_type: 'tinyint'
  default_value: 0
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "username",
  { data_type => "varchar", is_nullable => 0, size => 20 },
  "password",
  { data_type => "varchar", is_nullable => 0, size => 45 },
  "email",
  { data_type => "varchar", is_nullable => 1, size => 45 },
  "first_name",
  { data_type => "varchar", is_nullable => 1, size => 35 },
  "last_name",
  { data_type => "varchar", is_nullable => 1, size => 35 },
  "created_at",
  {
    data_type => "datetime",
    datetime_undef_if_invalid => 1,
    default_value => "CURRENT_TIMESTAMP",
    is_nullable => 1,
    set_on_create => 1,
  },
  "updated_at",
  {
    data_type => "datetime",
    datetime_undef_if_invalid => 1,
    default_value => "CURRENT_TIMESTAMP",
    is_nullable => 1,
    set_on_create => 1, 
    set_on_update => 1,
  },
  "is_deleted",
  { data_type => "tinyint", default_value => 0, is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 UNIQUE CONSTRAINTS

=head2 C<username_UNIQUE>

=over 4

=item * L</username>

=back

=cut

__PACKAGE__->add_unique_constraint("username_UNIQUE", ["username"]);

=head1 RELATIONS

=head2 notes

Type: has_many

Related object: L<Yoyotest::Model::Result::Note>

=cut

__PACKAGE__->has_many(
  "notes",
  "Yoyotest::Model::Result::Note",
  { "foreign.user_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07046 @ 2017-04-19 21:24:15
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:sZRk8fKCm60ZQE6ydMX0ig


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
