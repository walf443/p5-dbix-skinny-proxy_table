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
    if ( ref $func && ref $func eq "CODE" ) {
        return $func->(@default_args, @args);
    } else {
        return $self->$func(@default_args, @args);
    }
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
__END__

=head1 NAME

DBIx::Skinny::ProxyTable::Rule

=head1 SYNOPSIS

  my $rule = Proj::DB->proxy_table->rule('access_log', DateTime->today);
  $rule->table_name; #=> "access_log_200901"

  # create table that name is "access_log_200901"
  $rule->copy_table;

  my $iter = $rule->search({ foo => 'bar' });

=head1 DESCRIPTION

When DBIx::Skinny::ProxyTable::Rule was created,
it decide table name by rule and set schema information to your project skinny's schema.

You can handle dynamic table by natural interface.

=head1 METHOD

=head2 copy_table

It's just shortcut for
    Proj::DB->proxy_table->copy_table($rule->{base_table}, $rule->table_name)

=head2 search

It's just shortcut for
    Proj::DB->search($rule->table_name, $args);

=head1 AUTHOR

Keiji Yoshimi E<lt>walf443 at gmail dot comE<gt>

=head1 SEE ALSO

+<DBIx::Skinny::ProxyTable>, +<DBIx::Skinny::Schema::ProxyTableRule>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
