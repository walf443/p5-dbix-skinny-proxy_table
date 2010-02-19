use lib './t';
use Test::More;
use Test::Exception;
use Mock::Basic;

my $skinny = Mock::Basic->new;
$skinny->setup_test_db;

subtest 'user defined rule' => sub {
    my $rule = $skinny->proxy_table->rule('ranking', 'daily');
    $rule->copy_table;
    is($rule->table_name, 'ranking_daily', 'user defined rule name is ok');

    done_testing();
};

subtest 'strftime with DateTime' => sub {
    eval "use DateTime";
    plan skip_all => 'this test require DateTime' if $@;
    {
        my $dt = DateTime->new(year => 2010, month => 1, day => 1);
        my $rule = $skinny->proxy_table->rule('access_log', $dt);
        is($rule->table_name, 'access_log_201001', 'strftime ok');
    }
    {
        my $dt = DateTime->new(year => 2010, month => 2, day => 1);
        my $rule = $skinny->proxy_table->rule('access_log', $dt);
        $rule->copy_table;
        is($rule->table_name, 'access_log_201002', 'strftime ok');
    }
    done_testing();
};

subtest 'strftime with Time::Piece' => sub {
    eval { require 'Time::Piece' };
    plan skip_all => 'this test require Time::Piece' if $@;
    my $piece = Time::Piece->strptime('2010-01-01', '%Y-%m-%d');
    my $rule = $skinny->proxy_table->rule('access_log', $piece);
    $rule->copy_table;
    is($rule->table_name, 'access_log_201001', 'strftime ok ( with Time::Piece)');
    done_testing();
};

subtest 'sprintf rule' => sub {
    my $rule = $skinny->proxy_table->rule('error_log', '20100101');
    is($rule->table_name, 'error_log_20100101', 'sprintf ok');
    done_testing();
};


done_testing();

