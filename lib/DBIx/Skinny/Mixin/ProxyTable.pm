package DBIx::Skinny::Mixin::ProxyTable;
use strict;
use warnings;

sub register_method {
    +{
        proxy_table => \&proxy_table,
    };
}

sub proxy_table {
    my $self = shift;
    DBIx::Skinny::ProxyTable->new($self);
}

1;
