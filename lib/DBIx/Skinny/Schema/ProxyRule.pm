package DBIx::Skinny::Schema::ProxyRule;
use strict;
use warnings;

sub import {
    my $caller = caller;
    my $_proxy_rule = {};
    {
        no strict 'refs';
        *{"$caller\::proxy_rules"} = sub { $_proxy_rule };
        *{"$caller\::proxy_rule"} = \&proxy_rule;
    }
}

sub proxy_rule(@) { ## no critic
    my ($func, @args) = @_;
    my $class = caller;
    $class->proxy_rules->{ $class->schema_info->{_installing_table} } = [ @_ ];
}

1;
