use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME          => 'Catalyst::Example::InstantCRUDStylish',
    AUTHOR        => '<Zbigniew Lukasiak> <<zz bb yy @ gmail.com>>',
    VERSION_FROM  => 'lib/Catalyst/Example/InstantCRUDStylish.pm',
    ABSTRACT_FROM => 'lib/Catalyst/Example/InstantCRUDStylish.pm',
    PL_FILES      => {},
    PREREQ_PM     => {
        'Catalyst::Runtime'                       => '5.80006',
        'Catalyst::Devel'                         => '1.00',
        'Catalyst::View::TT'                      => '0.21',
        'DBIx::Class'                             => '0.08003',
        'DBIx::Class::Schema::Loader'             => '0.03',
        'DBIx::Class::ResultSet::RecursiveUpdate' => 0,
        'DBIx::Class::UTF8Columns'                => 0,

        #        'DBIx::Class::DigestColumns'                             => 0,
        #        'Template::Plugin::Class'                                => 0,
        'Catalyst::Model::DBIC::Schema'         => 0.29,
        'Catalyst::Helper::Model::DBIC::Schema' => 0,
        'Catalyst::Plugin::ConfigLoader'        => 0,
        'Catalyst::Plugin::Static::Simple'      => 0,
        'Catalyst::Plugin::Unicode'             => 0,

    #        'Catalyst::Plugin::Authentication'                       => '0.07',
    #        'Catalyst::Plugin::Authentication::Store::DBIC'          => '0.07',
    #        'Catalyst::Plugin::Authentication::Credential::Password' => 0,
        'Catalyst::Plugin::Session::State::Cookie'   => 0,
        'Catalyst::Plugin::Session::Store::FastMmap' => 0,
        'HTML::FormHandler::Generator::DBIC'         => 0.03,
        'HTML::FormHandler::Model::DBIC'             => 0.04,
        'HTML::FormHandler'                          => 0.26,
        'Path::Class'                                => 0,

        #        'URI::Escape'                                            => 0,
        'File::Slurp'                                => 0,
        'Pod::Usage'                                 => 0,
        'List::Util'                                 => 0,
        'String::Random'                             => 0,
        'Catalyst::Plugin::StackTrace'               => 0,
        'Catalyst::Plugin::Authentication'           => 0,
        'Catalyst::Plugin::Authorization::Roles'     => 0,
        'Catalyst::Plugin::Session'                  => 0,
        'Catalyst::Plugin::Session::Store::FastMmap' => 0,
        'Catalyst::Plugin::Session::State::Cookie'   => 0,
        'Catalyst::Plugin::Cache'                    => 0,
        'Catalyst::Plugin::Cache::FastMmap'          => 0,
        'Catalyst::Plugin::PageCache'                => 0,
    },
    dist => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean => { FILES => 'Catalyst-Example-InstantCRUDStylish-*' },
    EXE_FILES => ['script/instantcrudstylish.pl'],
    LICENSE   => 'perl',
);

