package DBIx::Skinny::Schema::ProxyTableRule;
use strict;
use warnings;

sub import {
    my $caller = caller;
    my $_proxy_table_rule = {};
    {
        no strict 'refs';
        *{"$caller\::proxy_table_rules"} = sub { $_proxy_table_rule };
        *{"$caller\::proxy_table_rule"} = \&proxy_table_rule;
    }
}

sub proxy_table_rule(@) { ## no critic
    my ($func, @args) = @_;
    my $class = caller;
    $class->proxy_table_rules->{ $class->schema_info->{_installing_table} } = [ @_ ];
}

1;
