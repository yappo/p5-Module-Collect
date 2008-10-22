use strict;
use warnings;
use Test::More tests => 14;

use File::Spec::Functions;

use Module::Collect;

my $collect = Module::Collect->new( path => [ catfile('t', 'plugin3') ] );

do {
    my ($module) = grep { $_->package eq 'Three::Bar' } @{ $collect->modules };
    isa_ok $module, 'Module::Collect::Package';
    ok !grep { $_ eq catfile('t', 'plugin3', 'three.pm') } keys %INC;
    ok $module->require;
    ok grep { $_ eq catfile('t', 'plugin3', 'three.pm') } keys %INC;

    my $obj = $module->new({ three => 3 });
    ok $obj;
    isa_ok $obj, 'Three::Bar';
    is $obj->three, 3;
};

do {
    # ThreeBar
    my ($module) = grep { $_->package eq 'ThreeBar' } @{ $collect->modules };
    isa_ok $module, 'Module::Collect::Package';
    ok grep { $_ eq catfile('t', 'plugin3', 'three.pm') } keys %INC;
    ok $module->require;
    ok grep { $_ eq catfile('t', 'plugin3', 'three.pm') } keys %INC;

    my $obj = $module->new({ three => 3 });
    ok $obj;
    isa_ok $obj, 'ThreeBar';
    is $obj->three, 1;
};
