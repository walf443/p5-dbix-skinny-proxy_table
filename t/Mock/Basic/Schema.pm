package Mock::Basic::Schema;
use DBIx::Skinny::Schema;
use DBIx::Skinny::Schema::ProxyTableRule;

install_table 'access_log' => schema {
    proxy_table_rule 'strftime', 'access_log_%Y%m';

    pk 'id';
    columns qw/
        id
        accessed_on
        count
    /;
};

1;
