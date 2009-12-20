use inc::Module::Install;
name 'Module-Collect';
all_from 'lib/Module/Collect.pm';

requires 'Carp';
requires 'File::Find::Rule';
requires 'File::Spec::Functions';

build_requires 'Test::More';
build_requires 'File::Spec';

use_test_base;
auto_include;
WriteAll;
