use strict;
use warnings;
use Test::More tests => 6;

use File::Spec::Functions;

use Module::Collect;

my $collect = Module::Collect->new( path => [ catfile('t', 'plugin1') ]);
my $module = $collect->modules->[0];
isa_ok $module, 'Module::Collect::Package';
ok $module->require;
ok grep {$_ eq catfile('t', 'plugin1', 'one.pm')} keys %INC;
my $obj = $module->new;
ok $obj;
isa_ok $obj, 'One';
my $obj2 = $module->new({one => 2});
is $obj2->one, 2;
