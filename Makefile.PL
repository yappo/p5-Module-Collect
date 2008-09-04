use inc::Module::Install;
name 'Module-Collect';
all_from 'lib/Module/Collect.pm';

requires 'Carp';
requires 'File::Find::Rule';
requires 'File::Spec::Functions';

build_requires 'Test::More';
use_test_base;
auto_include;
WriteAll;
