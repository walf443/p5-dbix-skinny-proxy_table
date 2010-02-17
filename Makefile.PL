use inc::Module::Install;
use Module::Install::ReadmeFromPod;
name 'DBIx-Skinny-ProxyTable';
all_from 'lib/DBIx/Skinny/ProxyTable.pm';
readme_from 'lib/DBIx/Skinny/ProxyTable.pm';

# requires '';

tests 't/*.t';
author_tests 'xt';

requires 'DBIx::Skinny';
requires 'Carp';

build_requires 'Test::More';
build_requires 'DateTime';
build_requires 'Time::Piece';
build_requires 'Test::LoadAllModules';
build_requires 'Module::Install::ReadmeFromPod';
use_test_base;
auto_include;
WriteAll;
