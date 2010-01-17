package DBIx::Skinny::ProxyTable;
use strict;
use warnings;
our $VERSION = '0.01';
use DBIx::Skinny::ProxyTable::Rule;

sub new {
    my ($class, $skinny) = @_;
    my $self = { skinny => $skinny };
    bless $self, __PACKAGE__;
    return $self;
}

sub skinny {
    my $self = $_[0];
    $self->{skinny};
}

sub set {
    my ($self, $from, $to) = @_;
  
    my $skinny = $self->skinny;
    my $schema = $skinny->schema;
    my $_schema_info = $schema->schema_info;
    $_schema_info->{$to} = $_schema_info->{$from};
  
    my $row_class_map;
    my $klass;
    if (ref $self) {
        $row_class_map = $skinny->{row_class_map};
        $klass = $skinny->{klass};
    }
    else {
        $row_class_map = $skinny->attribute->{row_class_map};
        $klass = $skinny;
    }

    my $tmp_base_row_class = join '::', $klass, 'Row', _camelize($from);
    eval "use $tmp_base_row_class"; ## no critic
    if ($@) {
        $row_class_map->{$to} = 'DBIx::Skinny::Row';
    } else {
        $row_class_map->{$to} = $tmp_base_row_class;
    }
}

sub _camelize {
    my $s = shift;
    join('', map{ ucfirst $_ } split(/(?<=[A-Za-z])_(?=[A-Za-z])|\b/, $s));
}

sub copy_table {
    my ($self, $from, $to) = @_;
    my $dbd = $self->skinny->dbd && ref $self->skinny->dbd;
    if ( $dbd && $dbd =~ /^DBIx::Skinny::DBD::(.+)$/ ) {
        $dbd = $1;
        if ( $dbd eq 'mysql' ) {
            $self->skinny->do(sprintf(q{ CREATE TABLE IF NOT EXISTS %s LIKE %s }, $from, $to));
        } elsif ( $dbd eq 'SQLite' ) {
            my $sql = $self->skinny->search_by_sql(q{
                SELECT sql FROM
                    ( SELECT * FROM sqlite_master UNION ALL
                    SELECT * FROM sqlite_temp_master)
                WHERE type != 'meta' and tbl_name = ?
            }, [ $from ])->first->sql;
            $sql =~ s/TABLE $from \(/TABLE IF NOT EXISTS $to (/;
            $self->skinny->do($sql);
        } else {
            die "DBIx::Skinny::DBD::$dbd is not supported";
        }
    }
}

sub rule {
    my ($self, $base, @args) = @_;
    return DBIx::Skinny::ProxyTable::Rule->new($self, $base, @args);
}

1;
__END__

=head1 NAME

DBIx::Skinny::ProxyTable -

=head1 SYNOPSIS

  package Proj::DB;
  use DBIx::Skinny;
  use DBIx::Skinny::Mixin modules => [qw(ProxyTable)];

  package Proj::DB::Schema;
  use DBIx::Skinny::Schema;
  use DBIx::Skinny::Schema::ProxyRule;

  install_table 'access_log' => shcema {
    proxy_rule 'strftime', 'access_log_%Y%m';

    pk 'id';
    columns qw/id/;
  };

  package main;

  Proj::DB->proxy_table->set(access_log => "access_log_200901");
  Proj::DB->proxy_table->copy_table(access_log => "access_log_200901");
  my $rule = Proj::DB->proxy_table->rule('access_log', DateTime->today);
  $rule->table_name; #=> "access_log_200901"
  if ( !$rule->is_table_exist ) {
    $rule->copy_table;
  }

  my $iter = $rule->search({ foo => 'bar' });

=head1 DESCRIPTION

DBIx::Skinny::ProxyTable is

=head1 AUTHOR

Keiji Yoshimi E<lt>walf443 at gmail dot comE<gt>

=head1 SEE ALSO

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
