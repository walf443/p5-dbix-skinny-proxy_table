use lib './t';
use Test::More;
use Test::Exception;
use Mock::Basic;
use DateTime;

my $skinny = Mock::Basic->new;
$skinny->setup_test_db;

{
    my $dt = DateTime->new(year => 2010, month => 1, day => 1);
    my $rule = $skinny->proxy_table->rule('access_log', $dt);
    is($rule->table_name, 'access_log_201001', 'strftime ok');
}
{
    my $dt = DateTime->new(year => 2010, month => 2, day => 1);
    my $rule = $skinny->proxy_table->rule('access_log', $dt);
    is($rule->table_name, 'access_log_201002', 'strftime ok');
}

done_testing();

