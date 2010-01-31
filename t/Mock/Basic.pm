package Mock::Basic;
use DBIx::Skinny setup => +{
    dsn => 'dbi:SQLite:',
    username => '',
    password => '',
};

use DBIx::Skinny::Mixin modules => [qw(ProxyTable)];

sub setup_test_db {
    my $self = shift;
    $self->do(q{
        CREATE TABLE access_log (
            id   INT,
            accessed_on  DATE,
            count           INT
        )
    });
    $self->do(q{
        CREATE TABLE ranking (
            id   INT,
            rank INT,
            count INT,
            ranked_on DATE
        )
    });
}

sub creanup_test_db {
}

1;

