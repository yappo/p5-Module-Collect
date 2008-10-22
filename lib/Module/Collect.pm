package Module::Collect;
use strict;
use warnings;
our $VERSION = '0.04';

use Carp;
use File::Find::Rule;
use Module::Collect::Package;

sub new {
    my($class, %args) = @_;

    $args{modules}  = [];
    $args{pattern} = '*.pm' unless $args{pattern};

    my $self = bless { %args }, $class;
    $self->_find_modules;

    $self;
}

sub _find_modules {
    my $self = shift;

    my $path = $self->{path} || [];
       $path = [ $path ] unless ref($path) eq 'ARRAY';

    for my $dirpath (@{ $path }) {
        next unless -d $dirpath;

        my $rule = File::Find::Rule->new;
        $rule->file;
        $rule->name($self->{pattern});

        my @modules = $rule->in($dirpath);
        for my $modulefile (@modules) {
            $self->_add_module($modulefile);
        }
    }
}

sub _add_module {
    my($self, $modulefile) = @_;
    my @packages = $self->_extract_package($modulefile);
    return unless @packages;
    for (@packages) {
        push @{ $self->{modules} },Module::Collect::Package->new(
            package => $_,
            path    => $modulefile,
        );
    }
}

sub _extract_package {
    my($self, $modulefile) = @_;

    open my $fh, '<', $modulefile or croak "$modulefile: $!";
    my $prefix = $self->{prefix};
    $prefix .= '::' if $prefix;
    $prefix = '' unless $prefix;

    my $in_pod = 0;
    my @packages;
    while (<$fh>) {
        $in_pod = 1 if m/^=\w/;
        $in_pod = 0 if /^=cut/;
        next if ($in_pod || /^=cut/);  # skip pod text
        next if /^\s*\#/;

        /^\s*package\s+($prefix.*?)\s*;/ and push @packages, $1;
    }
    return @packages;
}

sub modules {
    my $self = shift;
    $self->{modules};
}

1;
__END__

=encoding utf8

=head1 NAME

Module::Collect - module files are collected from some directories

=head1 SYNOPSIS

  use Module::Collect;
  my $collect = Module::Collect->new(
      path   => '/foo/bar/plugins',
      prefix => 'MyApp::Plugin', # not required option
      pattern => '*.pm',         # not required option
  );

  my @modules = @{ $collect->modules };
  for my $module (@modules) {
      print $module->path;    # package fuke oatg
      print $module->package; # package name
      $module->require;       # require package
      my $obj = $module->new; # aliae for $module->package->new
  }

=head1 DESCRIPTION

The following directory composition

  $ ls -R t/plugins
  t/plugins:
  empty.pm  foo  foo.pm  pod.pm  withcomment.pm  withpod.pm

  t/plugins/foo:
  bar.pm  baz.plugin

The following code is executed

  use strict;
  use warnings;
  use Module::Collect;
  use Perl6::Say;

  my $c = Module::Collect->new( path => 't/plugins' );
  for my $module (@{ $c->modules }) {
      say $module->package . ', ', $module->path;
      $module->require;
  }

results

  MyApp::Foo, t/plugins/foo.pm
  With::Comment, t/plugins/withcomment.pm
  With::Pod, t/plugins/withpod.pm
  MyApp::Foo::Bar, t/plugins/foo/bar.pm

=head1 AUTHOR

Kazuhiro Osawa E<lt>ko@yappo.ne.jpE<gt>

=head1 INSPIRED BY

L<Plagger>, L<Module::Pluggable>

=head1 SEE ALSO

L<Module::Collect::Package>

=head1 REPOSITORY

  svn co http://svn.coderepos.org/share/lang/perl/Module-Collect/trunk Module-Collect

Module::Collect is Subversion repository is hosted at L<http://coderepos.org/share/>.
patches and collaborators are welcome.

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
