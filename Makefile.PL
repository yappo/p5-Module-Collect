use inc::Module::Install;
name 'Module-Collect';
all_from 'lib/Module/Collect.pm';
readme_from 'lib/Module/Collect.pm';
readme_pod_from 'lib/Module/Collect.pm';
githubmeta;

requires 'Carp';
requires 'File::Find::Rule';
requires 'File::Spec::Functions';

build_requires 'Test::More';
build_requires 'File::Spec';

auto_set_repository;
auto_include;
WriteAll;
