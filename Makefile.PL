use inc::Module::Install;
name 'Module-Collect';
all_from 'lib/Module/Collect.pm';

requires 'Carp';
requires 'File::Find::Rule';

build_requires 'Test::More';
build_requires 'File::Spec';
build_requires 'File::Spec::Functions';

use_test_base;
auto_include;
WriteAll;
