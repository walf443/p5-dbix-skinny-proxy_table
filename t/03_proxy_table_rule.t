use lib './t';
use Test::More;
use Test::Exception;
use Mock::Basic;
use DateTime;
use Time::Piece;

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
    $rule->copy_table;
    my $iter = $rule->search({ count => 10 });
    is($rule->table_name, 'access_log_201002', 'strftime ok');
}

{
    my $piece = Time::Piece->strptime('2010-01-01', '%Y-%m-%d');
    my $rule = $skinny->proxy_table->rule('access_log', $piece);
    $rule->copy_table;
    my $iter = $rule->search({ count => 10 });
    is($rule->table_name, 'access_log_201001', 'strftime ok ( with Time::Piece)');
}

{
    my $rule = $skinny->proxy_table->rule('ranking', 'daily');
    $rule->copy_table;
    is($rule->table_name, 'ranking_daily', 'user defined rule name is ok');

}

done_testing();

