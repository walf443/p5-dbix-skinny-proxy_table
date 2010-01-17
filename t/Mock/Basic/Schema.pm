package Mock::Basic::Schema;
use DBIx::Skinny::Schema;
use DBIx::Skinny::Schema::ProxyRule;

install_table 'access_log' => schema {
    proxy_rule 'strftime', 'access_log_%Y%m';

    pk 'id';
    columns qw/
        id
        accessed_on
        count
    /;
};

1;
