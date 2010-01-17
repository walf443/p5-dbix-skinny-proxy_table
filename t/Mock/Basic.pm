package Mock::Basic;
use DBIx::Skinny setup => +{
    dsn => 'dbi:SQLite:',
    username => '',
    password => '',
};

use DBIx::Skinny::Mixin modules => [qw(ProxyTable)];

sub setup_test_db {
    shift->do(q{
        CREATE TABLE access_log (
            id   INT,
            accessed_on  DATE,
            count           INT
        )
    });
}

sub creanup_test_db {
}

1;

