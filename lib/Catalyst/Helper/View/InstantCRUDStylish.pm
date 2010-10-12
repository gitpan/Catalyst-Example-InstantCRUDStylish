package Catalyst::Helper::View::InstantCRUDStylish;

our $VERSION = '0.08';

use warnings;
use strict;
use Carp;
use Path::Class;
use List::Util qw(first);

sub mk_compclass {
    my ( $self, $helper, $schema, $m2m, $bridges ) = @_;

    my $file = $helper->{file};
    $helper->render_file( 'compclass', $file );

    my @classes = map {
        $bridges->{ $_ } ? () : $_
    } $schema->sources;
    my $dir = dir( $helper->{dir}, 'root' );
    $helper->mk_dir($dir);

    # TT View
    $helper->mk_component( $helper->{app}, 'view', $helper->{name}, 'TT' );
    
    # left_menu
    my $table_menu;
    $table_menu .= '<div class="left-menu">';
    $table_menu .= "  <a class='loud' href='/'><img src='/static/images/iconpack/house.png'/>Home</a>";
    for my $c (@classes) {
        $table_menu .= "  <a class='quiet' href='[% base %]" . lc($c) ."'><img src='/static/images/iconpack/user_suit.png'/>" . qq{$c} . "</a>";
    }
    $table_menu .= "  <a class='quiet' href='/logout'><img src='/static/images/iconpack/door_out.png'/>Logout</a>";
    $table_menu .= "</div>";
   
    # static files
    $helper->render_file( home => file( $dir, 'home.tt' ) );
    $helper->render_file( restricted => file( $dir, 'restricted.tt' ) );
    $helper->mk_file( file( $dir, 'wrapper.tt' ), $helper->get_file( __PACKAGE__, 'wrapper' ) );
    $helper->mk_file( file( $dir, 'login.tt' ), $helper->get_file( __PACKAGE__, 'login' ) );
    $helper->mk_file( file( $dir, 'pager.tt' ), $helper->get_file( __PACKAGE__, 'pager' ) );

    my $ajaxviewdir = dir( $helper->{dir}, 'root', 'src' );
    $helper->mk_dir( $ajaxviewdir );
    $helper->mk_file( file( $ajaxviewdir, 'wrapper.ajax.tt2' ) , $helper->get_file( __PACKAGE__, 'ajaxwrapper' ) );


    my $includedir = dir( $helper->{dir}, 'root', 'src', 'include' );
    $helper->mk_dir( $includedir );
    $helper->mk_file( file( $includedir, 'left_menu.tt2' ), $table_menu );
    $helper->mk_file( file( $includedir, 'common_htmlhead.tt' ), $helper->get_file( __PACKAGE__, 'common_htmlhead' ) );
#Header
    $helper->mk_file( file( $includedir, 'header.tt2' ) , $helper->get_file( __PACKAGE__, 'header' ) );

#Footer
    $helper->mk_file( file( $includedir, 'footer.tt2' ) , $helper->get_file( __PACKAGE__, 'footer' ) );



    my $appdir = $helper->{dir} ;
    $appdir =~ s/-/\//g;
    my $viewdirs = dir( $helper->{dir}, 'lib', $appdir, 'View' );
    $helper->render_file( ajaxview => file( $viewdirs, 'Ajax.pm' )  );

#    $helper->mk_file( file( $dir, 'destroy.tt' ), $helper->get_file( __PACKAGE__, 'destroy' ) );
    my $staticdir = dir( $helper->{dir}, 'root', 'static' );
    $helper->mk_dir( $staticdir );
    $helper->render_file( style => file( $staticdir, 'pagingandsort.css' ) );
    $helper->render_file( form_style => file( $staticdir, 'form.css' ) );

    # javascript
#    $helper->mk_file( file( $staticdir, 'doubleselect.js' ),
#        HTML::Widget::Element::DoubleSelect->js_lib );
    
    # templates
    for my $class (@classes){
        my $classdir = dir( $helper->{dir}, 'root', lc $class );
        $helper->mk_dir( $classdir );
        $helper->{field_configs} = _get_column_config( $schema, $class, $m2m ) ;
        my $source = $schema->source($class);
        $helper->{primary_keys} = [ $source->primary_columns ];
        $helper->{base_pathpart} = '/' . lc $class . '/';
        foreach my $page (qw/list view edit edit_ajax destroy/) {
            $helper->render_file( $page => file( $classdir, "${page}.tt" ));
        }
    }
    return 1;
}
sub _mk_label {
    my $name = shift;
    return join ' ', map { ucfirst } split '_', $name;
}

sub _get_column_config {
    my( $schema, $class, $m2m ) = @_;
    my @configs;
    my $source = $schema->source($class);
    my %bridge_cols;
    for my $rel ( $source->relationships ) {
        my $info = $source->relationship_info($rel);
        $bridge_cols{$_} = 1 for  _get_self_cols( $info->{cond} );
        $m2m->{$class} and next if first { $_->[1] eq $rel } @{$m2m->{$class}};
        my $config = {
            name => $rel,
            label => _mk_label( $rel ),
        };
        $config->{multiple} = 1 if $info->{attrs}{accessor} eq 'multi';
        push @configs, $config;
    }
    for my $column ( $source->columns ) {
        next if $bridge_cols{$column};
        push @configs, {
            name => $column,
            column_info => $schema->source($class)->column_info($column),
            label => _mk_label( $column ),
        };
    }
    if( $m2m->{$class} ) {
        for my $m ( @{$m2m->{$class}} ){
            push @configs, {
                name => $m->[0],
                label => _mk_label( $m->[0] ),
                multiple => 1,
            };
        }
    }
    return \@configs;
}

sub _get_self_cols{
    my $cond = shift;
    my @cols;
    if ( ref $cond eq 'ARRAY' ){
        for my $c1 ( @$cond ){
            push @cols, get_self_cols( $c1 );
        }
    }
    elsif ( ref $cond eq 'HASH' ){
        for my $key ( values %{$cond} ){
            if( $key =~ /self\.(.*)/ ){
                push @cols, $1;
            }
        }
    }
    return @cols;
}



1; # Magic true value required at end of module
__DATA__

=begin pod_to_ignore

__compclass__
package [% class %];

use strict;
use base 'Catalyst::View::TT';

__PACKAGE__->config( 
    TEMPLATE_EXTENSION => '.tt',
    ENCODING           => 'UTF-8',
);

=head1 NAME

[% class %] - TT View for [% app %]

=head1 DESCRIPTION

TT View for [% app %].

=head1 AUTHOR

=head1 SEE ALSO

L<[% app %]>

[% author %]

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;



__ajaxwrapper__
[% content %]



__ajaxview__
[% TAGS <+ +> %]
package <+ app +>::View::Ajax;
use strict;
use base 'Catalyst::View::TT';

__PACKAGE__->config(
    # Set to 1 for detailed timer stats in your HTML as comments
    TIMER   => 0,
    # This is your wrapper template located in the 'root/src'
    WRAPPER => 'wrapper.ajax.tt2',
    # Change default TT extension
    TEMPLATE_EXTENSION => '.tt',
    # Set the location for TT files
    INCLUDE_PATH => [
            <+  app +>->path_to( 'root', 'src' ),
        ],
);


=head1 NAME

<+ app +>::View::TT - TT View for <+ app +>

=head1 DESCRIPTION

TT View for <+ app +>.

=head1 AUTHOR

=head1 SEE ALSO

L<<+ app +>>

ev,,,

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;


__header__
<div class="busca-topo span-24">
  <div class="span-9">
    YOURLOGO
  </div>
  <div class="span-15 last">
    <form method="GET" action="/control-panel/busca">
      <div class="span-2 paddingTop5">
        <label>Search: </label>
      </div>
      <div class="span-5">
        <input id="busca_term" name="busca_term" type="text" value="[% search_val %]"/>
      </div>
      <div class="span-1 paddingTop5">
        <label> on </label>
      </div>
      <div class="span-4">
        <select id="busca_por" name="busca_por" class="marginTop10">
          <option value="client_name">Name</option>
        </select>
      </div>
      <div class="span-2 last paddingTop10">
        <input type="submit" value="Search"/>
      </div>
    </form>
  </div>
</div>


__footer__
<div class="span-24 clear">
  <center>
    project <strong>Instant CRUD Stylish</strong> 2010 - Copyright <a href="/">Your Company</a> - Contatos: <strong>11-9999-9999</strong> 
  </center>
</div>


__list__
[% TAGS <+ +> %]
  <div class="span-4">
    [% PROCESS 'src/include/left_menu.tt2' %]
  </div>
  <div class="span-20 top-options last">
    <div class="span-17 last">  
    <a href="[% c.uri_for( 'edit') %]" title="new" class="positive button">
      <img src='/static/images/iconpack/add.png' alt=''></img>
     New 
      </a>  

        <a class="button negative" href="javascript: void(0)" onclick="show_confirm()">
          <img src='/static/images/iconpack/cross.png' alt=''></img>
          remove
        </a>
        <script type="text/javascript">
        function show_confirm()
        {
          var r=confirm("Confirm?");
          if (r==true)
          {
            $('#gridform').attr('action', '[% c.uri_for('destroy_multiple') %]'); document.gridform.submit();
          }
          else
          {
          }
        }
        </script>
    </div>
    <div class="span-3 last">  
       <input type="checkbox" id="select-all-checkbox" value="All"></input> All
       <script>
         $('#select-all-checkbox').click(function () { 
           var cheked_status= this.checked;
           $('[name=select-multiple]').each( function () {
             this.checked = cheked_status;
             });
           });
       </script>
    </div>
  </div>


  <div class="span-20 last">
    <div class="span-20 last">
      [% PROCESS pager.tt %]
    </div>
    <div class="span-20 last viewTitleBorders">
      <h1 class='loud'>[% page_html.title || item %]</h1>
    </div>
    <table class="span-20">
    <thead class="table-head">
      <tr>
        <th class="select-cell" colspan="2">
          <div class="span-20">  
              <+ FOR column = field_configs +>
                <+- IF column.multiple -+>
                  <+ column.name +>
                <+ ELSE +>
                  [% order_by_column_link('<+ column.name +>', '<+ column.label+>') %]
                <+ END +>
              <+ END +> 
           </div>
        </th>
      </tr>
    </thead>
    <form method="post" id="gridform" name="gridform">
      <tbody>
    [% SET i = 1; WHILE (row = result.next) ; i = i + 1%]
        <tr class='[% IF i mod 2 %]bg_tr[% END %]'>
        <td class="trBorders">
        <div class='span-17 last'>
          <div class='span-2 clear'><img src="/static/images/no_image.gif" width="70" height="70"></img></div>
          <div class='span-15 last'>
          <+ FOR column = field_configs +>
             <div class='span-15 '>
                <div class="span-3 clear quiet"><+ column.name +>:</div>
                <div class="span-12 last loud">
                    <+ IF column.multiple +>
                    [% FOR val = row.<+ column.name +>; val; ', '; END %]
                    <+ ELSE +>
                    [%  row.<+ 
                      IF (column.column_info.data_type == 'date') ;
                          column.name _ ".dmy('/')";
                      ELSE ;
                          column.name ;
                      END; +> %]
                    <+ END +>
                </div>
              </div>
        <+ END +> 


          </div>  
          </div>
        [% SET id = row.$pri %]
            <div class='span-3 last'>

              <div class='span-3 row-button'>
                <input name="select-multiple" type="checkbox" value="[% <+ FOR key = primary_keys +>row.<+ key +><+END+> %]"></input> Select
              </div>

              <div class='span-3 row-button'>
                <a class="positive" href="[% c.uri_for_action( '<+ base_pathpart +><+ IF rest +>by_id'<+ ELSE +>view'<+ END +>, [], <+ FOR key = primary_keys +>row.<+ key +>, <+ END +> ) %]">
                  <img src='/static/images/iconpack/application_go.png' alt=''></img>
                  view 
                </a>
              </div>

              <div class='span-3 row-button'>
              <a href="[% c.uri_for_action( '<+ base_pathpart +><+ IF rest +>by_id'<+ ELSE +>edit'<+ END +>, [], <+ FOR key = primary_keys +>row.<+ key +>, <+ END +><+ IF rest +>,'edit'<+ END +> ) %]">
                <img src='/static/images/iconpack/application_form_edit.png' alt=''></img>
                edit
              </a>
              </div>

              <div class='span-3 row-button'>
              <a class="thickbox negative" href="[% c.uri_for_action( '<+ base_pathpart +><+ IF rest +>by_id'<+ ELSE +>destroy'<+ END +>, [], <+ FOR key = primary_keys +>row.<+ key +>, <+ END +><+ IF rest +>,'destroy'<+ END +> , { height => 100, width => 215 , keepThis => 'true' , TB_iframe => 'true' , callback => 'reload_page', }) %]">
                <img src='/static/images/iconpack/delete.png' alt=''></img>
                remove
              </a>
              </div>

            </div>
        </td>

        </tr>
    [% END %]
      </tbody>
    </form>
    </table>
[% PROCESS pager.tt %]
</div>
<script>
    function reload_page() {
      window.location.reload();
      }
</script>


__view__
[% TAGS <+ +> %]
  <div class="span-4">
    [% PROCESS 'src/include/left_menu.tt2' %]
  </div>

  <div class="span-20 top-options last">
    <a class="button positive" href="[% c.uri_for( 'list' ) %]">
      <img src='/static/images/iconpack/application_view_list.png' alt='list' title="list"></img>
      list
    </a>
    <a class="button" href="[% c.uri_for( 'edit', <+ FOR key = primary_keys +>item.<+ key +><+END+>,  ) %]">
      <img src='/static/images/iconpack/application_edit.png' alt='edit' title="edit"></img>
      editt
    </a>
      <a class="thickbox negative button" href="[% c.uri_for( 'destroy', <+ FOR key = primary_keys +>item.<+ key +><+END+> , { height => 100, width => 400 }  ) %]">
        <img src='/static/images/iconpack/delete.png' alt='delete' title="delete"></img>
        remove
      </a>
    
    <div class="span-20 last">
      <div class="span-20 last viewTitleBorders">
        <h1 class='loud'>[% page_html.title || item %]</h1>
      </div>
      <div class='span-3 clear'>
        <img src="/static/images/no_image.gif" width="70" height="70"></img>
      </div>
      <div class="span-17 last">
        <+ FOR column = field_configs +>
          <+ IF !column.multiple +>
            <div class='span-17 borderBottomlight'>
                <div class="quiet span-3 clear">
                  <+ column.label +>:
                </div>  
                <div class="loud span-14 last">
                  <+ IF column.multiple +>
                  [% FOR val = item.<+ column.name +>; val; ', '; END %]
                  <+ ELSE +>
                  [%  item.<+ 
                        IF (column.column_info.data_type == 'date') ;
                            column.name _ ".dmy('/')";
                        ELSE ;
                            column.name || '-' ;
                        END;
                  +> %]
                  <+ END +>
                </div>  
            </div>  
          <+ END +>
        <+ END +>
      </div>

        <+ FOR column = field_configs +>
          <+ IF column.multiple +>
            <div class='span-20 '>
              <div class="span-3 clear quiet"><+ column.name +>:</div>
              <div class="span-17 borderBottomlight last">
                <div class="quiet span-1 clear">[% item.<+ column.name +>_rs.count %]</div>
                <div class="loud span-13 last">
                  [% IF item.<+ column.name +>_rs.count > 0 ; %]
                
                  [% FOR val = item.<+ column.name +>; %]

                      <div class="span-2 row-button clear">
                        <a href="/[% item.<+ column.name +>_rs.result_source.source_name FILTER lower %]/destroy/[% <+ FOR key = primary_keys +>val.<+ key +><+END+> %]?height=100&width=250&keepThis=true&TB_iframe=true&callback=reload_page" alt="Remove" title="Remove" class="thickbox negative">
                          <img title="list" alt="list" src="/static/images/iconpack/delete.png">
                          remove
                        </a>
                      </div>  
                        
                      <div class="loud span-11 last">
                        [% val || '-' %]
                      </div>  

                  [% END ; %]
                    
                  [% ELSE ; '-' ; END ; %]


                </div>

                <div class="loud span-3 last">
                    <div class="span-3 row-button">
                      <a alt="New" title="New" class="thickbox positive" href="/[% item.<+ column.name +>_rs.result_source.source_name FILTER lower %]/edit_ajax?height=400&width=750&keepThis=true&TB_iframe=true&callback=reload_page">
                      <img title="New" alt="New" src="/static/images/iconpack/add.png">
                      New
                      </a>
                    </div>  
                </div>  
              </div>
            </div>
          <+ END +> 
        <+ END +> 
    </div> 
  </div>
<script>
    function reload_page() {
      window.location.reload();
      }
</script>

__edit_ajax__
[% TAGS <+ +> %]

  [% PROCESS 'src/include/common_htmlhead.tt' %]
  <div class="span-20 top-options last">
    <div class="span-20 last">
        <div class="span-20 viewTitleBorders">
          <h1 class='loud'>[% page_html.title || item || 'New' %]</h1>
        </div>
        <div class="span-20">
          [% form.render %]
        </div>
    </div>
  </div>

__edit__
[% TAGS <+ +> %]

  <div class="span-4">
    [% PROCESS 'src/include/left_menu.tt2' %]
  </div>
  <div class="span-20 top-options last">
    <a class="button" href="[% c.uri_for( 'list' ) %]">
      <img src='/static/images/iconpack/application_view_list.png' alt='list' title="list"></img>
      list
    </a>

    <div class="span-20 last">
        <div class="span-20 viewTitleBorders">
          <h1 class='loud'>[% page_html.title || item %]</h1>
        </div>
        <div class="span-20">
          [% form.render %]
        </div>
    </div>
  </div>


__destroy__
[% TAGS <+ +> %]

  <div class="span-13 last">
    <div class="span-13 viewTitleBorders">
      <h1 class='loud'>[% page_html.title || item %]</h1>
    </div>
    <div class="span-13">
      [% destroywidget %]
    </div>
  </div>

__common_htmlhead__
    <!-- JQUERY -->
    <script type="text/javascript" src="/static/js/jquery-1.4.2.min.js"></script>
    <!-- thickbox -->
    <script type="text/javascript" src="/static/thickbox/thickbox.js"></script>
    <link rel="stylesheet" href="/static/thickbox/thickbox.css" type="text/css" media="screen" />
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <link rel="stylesheet" href="/static/css/painel-de-controle.css" type="text/css" media="screen, projection"/>   
    <!-- buttons http://particletree.com/features/rediscovering-the-button-element/ -->
    <link rel="stylesheet" href="/static/css/buttons.css" type="text/css" media="screen, projection"/>   
    <!-- buttons -->
    <!-- Blueprint CSS -->
    <link rel="stylesheet" href="/static/css/typography.css" type="text/css" media="screen, projection"/>   
    <link rel="stylesheet" href="/static/css/forms.css" type="text/css" media="screen, projection"/>   
    <link rel="stylesheet" href="/static/css/screen.css" type="text/css" media="screen, projection"/>   
    <link rel="stylesheet" href="/static/css/print.css" type="text/css" media="print"/>
    <!--[if lt IE 8]>
    <link rel="stylesheet" href="/static/css/ie.css" type="text/css" media="screen, projection"/>
    <![endif]-->  
    <!-- Blueprint CSS -->

__wrapper__
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN"
    "http://www.w3.org/TR/xhtml1/DTD/xhtml11.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>[% page_html.title %]</title>
    [% PROCESS 'src/include/common_htmlhead.tt' %]
</head>
<body>
    <div class='container'>

    [% IF (
         c.flash.message != ''
      || c.flash.error != ''
      )  %]

    <script>                                                                                                           
    $(document).ready(function () {                                                                                    
      tb_show('Aviso', '#TB_inline?height=200&width=400&inlineId=flash-messages', false);
    });
    </script>
    <div id="flash-messages" style="display:none;">                                                                    
      [% IF c.flash.message != '' %]<span class="success-msg">[% c.flash.message %]
      </span>[% END %]                                                                                                       
      [% IF c.flash.error != '' %]<span class="error-msg">[% c.flash.error  %]</span>[% END %]           
    </div>          

    [% END %]


    <div class='span-24'>
        [% INCLUDE 'src/include/header.tt2' %]
        [% content %]
        [% INCLUDE 'src/include/footer.tt2' %]
    </div>

    </div>
</body>
</html>

__login__
[% widget %]

__pager__
[% IF pager %]
<center>
    <div class="pagination-space">
      <div class="span-6 height35 paddingTop5 paddingBottom5">
      Pages:
[%#        Page pager.current_page of pager.last_page %]

       [%  
           start = (pager.current_page - 3) > 0               ? (pager.current_page - 3) : 1;
           end   = (pager.current_page + 3) < pager.last_page ? (pager.current_page + 3) : pager.last_page;
           FOREACH page IN [ start .. end  ]
       %] 
           [% IF pager.current_page == page %]
               <a class="current"> [% page %] </a>
           [% ELSE %]
               <a href="[% c.req.uri_with( page => page ) %]">[% page %]</a>
           [% END %]
       [% END %]
      </div>
      <div class="span-8 last height35 paddingTop5 paddingBottom5">
       [% IF pager.previous_page %]
           <a href="[% c.req.uri_with( page => pager.first_page ) %]" class="noborder">&laquo; First</a>
           <a href="[% c.req.uri_with( page => pager.previous_page ) %]" class="noborder">&lt; Before </a>
       [% END %]
        |
       [% IF pager.next_page %]
           <a href="[% c.req.uri_with( page => pager.next_page ) %]" class="noborder">After &gt; </a>
           <a href="[% c.req.uri_with( page => pager.last_page ) %]" class="noborder">Last &raquo; </a>
       [% END %]
      </div>
   </div>
</center>
[% END %]

__restricted__
Make login to acess this restricted area.
__home__
[% TAGS <+ +> %]

  <div class="span-4">
    [% PROCESS 'src/include/left_menu.tt2' %]
  </div>
    <div class="span-20 last">
        <div class="span-20 viewTitleBorders">
          <h1 class='loud'>Welcome</h1>
        </div>
        <div class="span-20">
          This is an application generated by  
          <a href="http://search.cpan.org/dist/Catalyst-Example-InstantCRUDStylish/lib/Catalyst/Example/InstantCRUDStylish.pm">Catalyst::Example::InstantCRUDStylish</a>
          - a generator of simple database applications for the 
          <a href="http://catalyst.perl.org">Catalyst</a> framework.
          See also 
          <a href="http://search.cpan.org/dist/Catalyst-Manual/lib/Catalyst/Manual/Intro.pod">Catalyst::Manual::Intro</a>
          and
          <a href="http://search.cpan.org/dist/Catalyst-Manual/lib/Catalyst/Manual/Tutorial.pod">Catalyst::Manual::Intro</a>
        </div>
  </div>


__style__
/* HTML TAGS */

body {
}

__END__

=head1 NAME

Catalyst::Helper::Controller::InstantCRUDStylish - [One line description of module's purpose here]


=head1 VERSION

This document describes Catalyst::Helper::Controller::InstantCRUDStylish version 0.0.1


=head1 SYNOPSIS

    use Catalyst::Helper::Controller::InstantCRUDStylish;

=for author to fill in:
    Brief code example(s) here showing commonest usage(s).
    This section will be as far as many users bother reading
    so make it as educational and exeplary as possible.
  
  
=head1 DESCRIPTION

=for author to fill in:
    Write a full description of the module and its features here.
    Use subsections (=head2, =head3) as appropriate.

=head2 METHODS

=over 4

=item mk_compclass

=back

=head1 INTERFACE 

=for author to fill in:
    Write a separate section listing the public components of the modules
    interface. These normally consist of either subroutines that may be
    exported, or methods that may be called on objects belonging to the
    classes provided by the module.


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
  
Catalyst::Helper::Controller::InstantCRUDStylish requires no configuration files or environment variables.


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
C<bug-catalyst-helper-controller-instantcrud@rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org>.


=head1 AUTHOR

<Zbigniew Lukasiak>  C<< <<zz bb yy @ gmail.com>> >>
Paginator adapted from example by Oliver Charles.

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


