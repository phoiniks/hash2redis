package Hash2Redis;

use Data::Dump qw( dump );
use Redis;

use Exporter qw( import );

our @EXPORT_OK = qw(
    extractKeysFromHashRef
    extractValuesFromHashRef
    hashref2arrayref
    setRedis
    getRedis
);


sub extractKeysFromHashRef {
    my $hashref = shift;

    my $idx;
    my @keys = map { $_ } sort { $a cmp $b } keys %$hashref;

    return sub {
	for ( @keys ){
	    return $keys[$idx++];
	}
    }
}


sub extractValuesFromHashRef {
    my $hashref = shift;

    my $idx;
    my @values = map { $hashref->{ $_ } } sort { $a cmp $b } keys %$hashref;

    return sub {
	for ( @values ){
	    return $values[$idx++];
	}
    }
}


sub hashref2arrayref {
    my $hashref = shift;

    my @array = map { $_, $hashref->{ $_ } } sort { $a cmp $b } keys %$hashref;

    return \@array;
}


sub setRedis {
    my $schluessel = shift;
    my $arrayref = shift;

    my $rds = Redis->new;

    $rds->hset( $schluessel, @{ $arrayref }, sub{} );
}


sub getRedis {
    my $schluessel = shift;

    my $rds = Redis->new;

    my %hash = $rds->hgetall( $schluessel );

    return { $schluessel => \%hash };
}

