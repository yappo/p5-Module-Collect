use strict;
use warnings;
use Test::More tests => 2;

use File::Spec::Functions;

use Module::Collect;

my $collect = Module::Collect->new( path => catfile('t', 'plugins') );

ok grep { $_ eq 'MyApp::Foo' } map { $_->{package} } @{ $collect->modules };
ok !(grep { $_ eq 'error' } map { $_->{package} } @{ $collect->modules });
