package DBIx::Skinny::ProxyTable::Rule;
use strict;
use warnings;
use Carp qw();

sub new {
    my ($class, $proxy_table, $base, @args) = @_;
    my $self = {
        proxy_table => $proxy_table,
        base_table  => $base,
    };
    bless $self, $class;
    $self->{table_name} = $self->_table_name(@args);
    $self->{proxy_table}->set($self->{base_table}, $self->table_name);
    return $self;
}

sub table_name {
    my $self = $_[0];
    $self->{table_name};
}

sub _table_name {
    my ($self, @args) = @_;

    my $rule = $self->{proxy_table}->{skinny}->schema->proxy_table_rules->{$self->{base_table}};
    unless ( $rule ) {
        Carp::croak("Cant' find proxy_table_rules for @{[ $self->{base_table} ]}");
    }
    my ($func, @default_args) = @{$rule};
    $self->$func(@default_args, @args);
}

sub is_table_exist {
    my $self = $_[0];
}

sub copy_table {
    my $self = $_[0];
    $self->{proxy_table}->copy_table($self->{base_table}, $self->table_name);
}

sub search {
    my $self = shift;
    $self->{proxy_table}->{skinny}->search($self->table_name, @_);
}

sub strftime {
    my ($self, $tmpl, $dt) = @_;
    $dt->strftime($tmpl);
}

sub sprintf {
    my ($self, $tmpl, @args) = @_;
    Core::sprintf($tmpl, @args);
}

1;
