use lib './t';
use Test::More;
use Test::Exception;
use Mock::Basic;

my $skinny = Mock::Basic->new;
$skinny->setup_test_db;

ok($skinny->can('proxy_table'), 'proxy_table can call');
isa_ok($skinny->proxy_table, 'DBIx::Skinny::ProxyTable');

my $table = "access_log_200901";

my $schema = $skinny->search_by_sql(q{
    SELECT sql FROM
        ( SELECT * FROM sqlite_master UNION ALL
        SELECT * FROM sqlite_temp_master)
    WHERE type != 'meta' and tbl_name = 'access_log'
    ORDER BY tbl_name, type DESC, name
})->first->sql;
$schema =~ s/TABLE access_log \(/TABLE $table (/;
$skinny->do($schema);

dies_ok {
    $skinny->search($table, {});
};

ok(!$skinny->attribute->{row_class_map}->{$table}, 'row class map should not be exist yet');
$skinny->proxy_table->set('access_log', $table);
ok($skinny->schema->schema_info->{$table}, 'schema_info should be exist ');
ok($skinny->attribute->{row_class_map}->{$table}, 'row class map should be exist');

lives_ok {
    $skinny->search($table, {});
};

done_testing();
