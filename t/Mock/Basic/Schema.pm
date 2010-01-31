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

sub ranking_rule {
    my ($base, $type,) = @_;
    if ( $type !~ /^(daily|weekly|monthly)$/ ) {
        die "invalid type";
    }
    return "${base}_${type}";
}

install_table 'ranking' => schema {
    proxy_table_rule \&ranking_rule, "ranking";

    pk 'id';
    columns qw/
        id
        rank
        count
        ranked_on
    /;
};

1;
