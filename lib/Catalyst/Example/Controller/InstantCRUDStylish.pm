package Catalyst::Example::Controller::InstantCRUDStylish;

use Moose;
use utf8;
BEGIN {
       extends 'Catalyst::Controller';
}

with 'Catalyst::Component::ContextClosure';

use Carp;
use Data::Dumper;
use Path::Class;

our $VERSION = '0.016';

has source_name => ( isa => 'Str', is => 'rw', lazy => 1, builder => 'build_source_name' );
sub build_source_name {
    my $self  = shift;
    my $class = ref $self;
    $class =~ /([^:]*)$/;
    return $1;
}

has form_class => ( isa => 'Str', is => 'rw', lazy => 1, builder => 'build_form_class' );
sub build_form_class {
    my $self  = shift;
    return ref( $self ) . '::' . $self->source_name . 'Form';
}

sub auto : Action {
    my ( $self, $c ) = @_;
    $c->stash->{additional_template_paths} = [ dir( $c->config->{root}, lc $self->source_name) . '', $c->config->{root} . ''];
}

sub model_item {
    my ( $self, $c, @pks ) = @_;
    my $rs = $self->model_resultset($c);
    my @pk_columns = $rs->result_source->primary_columns;
    my $data = {
        map { $pk_columns[$_] => $pks[$_] } 0..$#pk_columns
    };
    my $item = $rs->find($data, { key => 'primary' });
    return $item;
}

sub model_resultset {
    my ( $self, $c ) = @_;
    my $source     = $self->source_name;
    return $self->model_schema($c)->resultset($source);
}

sub model_schema {
    my ( $self, $c ) = @_;
    my $model_name = $c->config->{InstantCRUDStylish}{model_name};
    return $c->model($model_name);
}

sub index : Private {
    my ( $self, $c ) = @_;
    $c->stash->{template} = lc( $self->source_name ) . '/list.tt';
    $c->forward('list');
}

sub destroy : Action {
    my ( $self, $c, @pks ) = @_;
    $c->stash->{item} = $self->model_item( $c, @pks );
    next unless defined $c->stash->{item};
    if ( $c->req->method eq 'POST' ) {
        $self->model_item( $c, @pks )->delete();
        $c->stash(
          template => \'Deleted!',
          current_view => 'Ajax',
          ); 
        }
    else {
        my $action_uri = $c->uri_for( $self->action_for('destroy'), @pks);
        $c->stash->{destroywidget} = <<END;
<form action="$action_uri" id="remove-form" method="post">
<fieldset class="widget_fieldset">
<input class="submit" id="widget_ok" name="ok" type="submit" value="Confirm?" />
</fieldset>
</form>
END
        $c->stash(
          template => \$c->stash->{destroywidget},
          current_view => 'Ajax',
          ); 
    }
}

sub destroy_multiple : Local {
    my ( $self, $c, @pks ) = @_;
    my $counter = 0;

    if ( $c->req->method eq 'POST' ) {
        if ( defined $c->req->params->{'select-multiple'} ) {
            if ( ref $c->req->params->{'select-multiple'} ne 'ARRAY' ) {
                my $one_value = $c->req->params->{'select-multiple'};
                my @one_val_arr;
                push( @one_val_arr, $one_value );
                $c->req->params->{'select-multiple'} = \@one_val_arr;
            }

            foreach my $item_id ( @{ $c->req->params->{'select-multiple'} } ) {
                my $rs = $self->model_resultset($c);
                my $item =
                  $rs
                  ->find( { 'id' => $item_id } )
                  ->update( {  } );
                $counter++;
            }
        }
    $c->flash( message => $counter . ' itens removidos' );
    }
    $c->res->redirect( $c->uri_for('list') );
}

sub edit_ajax :Action {
    my ( $self, $c, @pks ) = @_;
    $c->stash(
        current_view => 'Ajax',
        );
    $c->forward('edit_item', @pks);
    }

sub edit_item : Private {
    my ( $self, $c, @pks ) = @_;
    my @ids;
    @ids = ( item_id => [ @pks ] ) if @pks;
    my $form = $self->form_class->new( 
        schema => $self->model_schema($c), 
        params => $c->req->params, 
        @ids,
    );
    my $item = $form->item;
    if( $c->req->method eq 'POST' && $form->process() ){
        $item = $form->item;
        $c->res->redirect( $c->uri_for( $self->action_for('view'), $item->id ) );
        $c->flash( message => 'Saved!' );
    }
    if( @pks ){
        $form->field( 'submit' )->value( 'Save' );
    }
    else{
        $form->field( 'submit' )->value( 'Save' );
    }

    $c->stash(
        form => $form,
        item => $item,
    );
    }

sub edit : Action {
    my ( $self, $c, @pks ) = @_; 
    $c->forward('edit_item', @pks);
    }

sub view : Action {
    my ( $self, $c, @pks ) = @_;
    die "You need to pass an id" unless @pks;
    my $item = $self->model_item( $c, @pks );
    $c->stash->{item} = $item;
}

sub get_resultset {
    my ( $self, $c ) = @_;
    my $params = $c->request->params;
    my $order = $params->{'order'};
    $order .= ' DESC' if $params->{'o2'};
    my $join;
    if ( $order && $order =~ m/(\w+)\.\w+/ ) {
        $join = $1;
    }
    my $maxrows = $c->config->{InstantCRUDStylish}{maxrows} || 10;
    my $page = $params->{'page'} || 1;
    return $self->model_resultset($c)->search(
        {  },
        {
            page     => $page,
            $join ? ( join => $join ) : (),
            order_by => $order,
            rows     => $maxrows,
        }
    );
}

sub create_col_link {
    my ( $self, $c, $source ) = @_;
    my $origparams = $c->request->params;
    return $self->make_context_closure(sub {
        my ( $ctx, $column, $label ) = @_;
        my $addr;
        no warnings 'uninitialized';
        if ( $origparams->{'order'} eq $column && !$origparams->{'o2'} ) {
            $addr = $ctx->request->uri_with({ page => 1, order =>  $column, o2 => 'desc' });
        }else{
            $addr = $ctx->request->uri_with({ page => 1, order =>  $column, o2 => undef });
        }
        my $result = qq{<a href="$addr">$label</a>};
        if ( $origparams->{'order'} && $column eq $origparams->{'order'} ) {
            $result .= $origparams->{'o2'} ? "&#9660;" : "&#9650;";
        }
        return $result;
    }, $c);
}

sub list : Action {
    my ( $self, $c ) = @_;
    my $result = $self->get_resultset($c);
    $c->stash->{pager}     = $result->pager;
    my $source  = $result->result_source;
    ($c->stash->{pri}) = $source->primary_columns;
    $c->stash->{order_by_column_link} = $self->create_col_link($c, $source);
    $c->stash->{result} = $result;
}



1;

__END__

=head1 NAME

Catalyst::Example::Controller::InstantCRUDStylish - Catalyst CRUD example Controller


=head1 VERSION

This document describes Catalyst::Example::Controller::InstantCRUDStylish version 0.0.14


=head1 SYNOPSIS

    use base Catalyst::Example::Controller::InstantCRUDStylish;

=for author to fill in:
    Brief code example(s) here showing commonest usage(s).
    This section will be as far as many users bother reading
    so make it as educational and exeplary as possible.
  
  
=head1 DESCRIPTION

=for author to fill in:
    Write a full description of the module and its features here.
    Use subsections (=head2, =head3) as appropriate.


=head1 INTERFACE 

=head2 METHODS

=over 4

=item load_interface_config
Returns the config hash for input forms (widgets) and other interface elements

=item get_resultset 
Returns the resultset appriopriate for the page parameters.

=item model_resultset
Returns a resultset from the model.

=item model_item
Returns an item from the model.

=item source_name
Class method for finding name of corresponding database table.

=item add
Method for displaying form for adding new records

=item create_col_link
Subroutine placed on stash for templates to use.

=item auto 
Adds Controller name as additional directory to search for templates

=item index
Forwards to list

=item destroy
Deleting records.

=item do_add
Method for adding new records

=item do_edit
Method for editin existing records

=item edit
Method for displaying form for editing a record.

=item list
Method for displaying pages of records

=item view
Method for diplaying one record

=back

=head1 DIAGNOSTICS

=for author to fill in:
    List every single error and warning message that the module can
    generate (even the ones that will "never happen"), with a full
    explanation of each problem, one or more likely causes, and any
    suggested remedies.

=over

=item C<< Error message here, perhaps with %s placeholders >>

[Description of error here]

=item C<< Another error message here >>

[Description of error here]

[Et cetera, et cetera]

=back


=head1 CONFIGURATION AND ENVIRONMENT

=for author to fill in:
    A full explanation of any configuration system(s) used by the
    module, including the names and locations of any configuration
    files, and the meaning of any environment variables or properties
    that can be set. These descriptions must also include details of any
    configuration language used.
  
Catalyst::Example::Controller::InstantCRUDStylish requires no configuration files or environment variables.


=head1 DEPENDENCIES

=for author to fill in:
    A list of all the other modules that this module relies upon,
    including any restrictions on versions, and an indication whether
    the module is part of the standard Perl distribution, part of the
    module's distribution, or must be installed separately. ]

None.


=head1 INCOMPATIBILITIES

=for author to fill in:
    A list of any modules that this module cannot be used in conjunction
    with. This may be due to name conflicts in the interface, or
    competition for system or program resources, or due to internal
    limitations of Perl (for example, many modules that use source code
    filters are mutually incompatible).

None reported.


=head1 BUGS AND LIMITATIONS

=for author to fill in:
    A list of known problems with the module, together with some
    indication Whether they are likely to be fixed in an upcoming
    release. Also a list of restrictions on the features the module
    does provide: data types that cannot be handled, performance issues
    and the circumstances in which they may arise, practical
    limitations on the size of data sets, special cases that are not
    (yet) handled, etc.

No bugs have been reported.

Please report any bugs or feature requests to
C<bug-catalyst-example-controller-instantcrud@rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org>.


=head1 AUTHOR

<Zbigniew Lukasiak>  C<< <<zz bb yy @ gmail.com>> >>
<Jonas Alves>  C<< <<jonas.alves at gmail.com>> >>
<Lars Balker Rasmussen>

=head1 CONTRIBUTORS

Hernan Lopes:  <hernanlopes [ @ ] gmail.com>

=head1 LICENCE AND COPYRIGHT

Copyright (c) 2005, <Zbigniew Lukasiak> C<< <<zz bb yy @ gmail.com>> >>. All rights reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself. See L<perlartistic>.


=head1 DISCLAIMER OF WARRANTY

BECAUSE THIS SOFTWARE IS LICENSED FREE OF CHARGE, THERE IS NO WARRANTY
FOR THE SOFTWARE, TO THE EXTENT PERMITTED BY APPLICABLE LAW. EXCEPT WHEN
OTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS AND/OR OTHER PARTIES
PROVIDE THE SOFTWARE "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER
EXPRESSED OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE. THE
ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE SOFTWARE IS WITH
YOU. SHOULD THE SOFTWARE PROVE DEFECTIVE, YOU ASSUME THE COST OF ALL
NECESSARY SERVICING, REPAIR, OR CORRECTION.

IN NO EVENT UNLESS REQUIRED BY APPLICABLE LAW OR AGREED TO IN WRITING
WILL ANY COPYRIGHT HOLDER, OR ANY OTHER PARTY WHO MAY MODIFY AND/OR
REDISTRIBUTE THE SOFTWARE AS PERMITTED BY THE ABOVE LICENCE, BE
LIABLE TO YOU FOR DAMAGES, INCLUDING ANY GENERAL, SPECIAL, INCIDENTAL,
OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE OR INABILITY TO USE
THE SOFTWARE (INCLUDING BUT NOT LIMITED TO LOSS OF DATA OR DATA BEING
RENDERED INACCURATE OR LOSSES SUSTAINED BY YOU OR THIRD PARTIES OR A
FAILURE OF THE SOFTWARE TO OPERATE WITH ANY OTHER SOFTWARE), EVEN IF
SUCH HOLDER OR OTHER PARTY HAS BEEN ADVISED OF THE POSSIBILITY OF
SUCH DAMAGES.
