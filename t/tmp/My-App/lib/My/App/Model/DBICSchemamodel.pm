package My::App::Model::DBICSchemamodel;

use strict;
use base 'Catalyst::Model::DBIC::Schema';

__PACKAGE__->config(
    schema_class => 'My::App::DBSchema',
    
    
);

=head1 NAME

My::App::Model::DBICSchemamodel - Catalyst DBIC Schema Model

=head1 SYNOPSIS

See L<My::App>

=head1 DESCRIPTION

L<Catalyst::Model::DBIC::Schema> Model using schema L<My::App::DBSchema>

=head1 GENERATED BY

Catalyst::Helper::Model::DBIC::Schema - 0.41

=head1 AUTHOR

User &

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
