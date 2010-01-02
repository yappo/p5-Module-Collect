use inc::Module::Install;
name 'Module-Collect';
all_from        'lib/Module/Collect.pm';
readme_from     'lib/Module/Collect.pm';
readme_pod_from 'lib/Module/Collect.pm';

requires 'File::Find::Rule';
requires 'Carp';
requires 'File::Spec';

test_requires 'Test::More';

auto_set_repository;
WriteAll;
