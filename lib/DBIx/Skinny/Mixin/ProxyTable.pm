package DBIx::Skinny::Mixin::ProxyTable;
use strict;
use warnings;
use DBIx::Skinny::ProxyTable;

sub register_method {
    +{
        proxy_table => \&proxy_table,
    };
}

sub proxy_table {
    my $self = shift;
    $self->{_cache_proxy_table} ||= DBIx::Skinny::ProxyTable->new($self);
}

1;
