package Module::Collect;
use strict;
use warnings;
our $VERSION = '0.01';

use Carp;
use File::Find::Rule;
use File::Spec::Functions;

sub new {
    my($class, %args) = @_;

    $args{modules} = [];
    my $self = bless { %args }, $class;
    $self->_find_modules;

    $self;
}

sub _find_modules {
    my $self = shift;

    my $path = $self->{path} || [];
       $path = [ $path ] unless ref $path;

    for my $dirpath (@{ $path }) {
        next unless -d $dirpath;

        my $rule = File::Find::Rule->new;
        $rule->file;
        $rule->name('*.pm');

        my @modules = $rule->in($dirpath);
        for my $modulefile (@modules) {
            $self->_add_module($modulefile);
        }
    }
}

sub _add_module {
    my($self, $modulefile) = @_;
    my $package = $self->_extract_package($modulefile);
    push @{ $self->{modules} }, +{
        package => $package,
        path    => $modulefile,
    };
}

sub _extract_package {
    my($self, $modulefile) = @_;

    open my $fh, '<', $modulefile or croak "$modulefile: $!";
    my $prefix = $self->{prefix};
    $prefix .= '::' if $prefix;
    $prefix = '' unless $prefix;

    while (<$fh>) {
        /^package ($prefix.*?);/ and return $1;
    }
    return;
}

sub modules {
    my $self = shift;
    $self->{modules};
}

1;
__END__

=encoding utf8

=head1 NAME

Module::Collect -

=head1 SYNOPSIS

  use Module::Collect;
  my $collect = Module::Collect->new(
      path   => '/foo/bar/plugins',
      prefix => 'MyApp::Plugin',
      parttern => '*.pm',
      with_requires => 1,
      # or
      with_requires => sub {
          my $class = shift;
          require "$class";
      },
  );

  my @modules = $collect->modules;

=head1 DESCRIPTION

Module::Collect is

=head1 AUTHOR

Kazuhiro Osawa E<lt>ko@yappo.ne.jpE<gt>

=head1 INSPIRED BY

L<Plagger>

=head1 SEE ALSO

=head1 REPOSITORY

  svn co http://svn.coderepos.org/share/lang/perl/Module-Collect/trunk Module-Collect

Module::Collect is Subversion repository is hosted at L<http://coderepos.org/share/>.
patches and collaborators are welcome.

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
