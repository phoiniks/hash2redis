package Hash2Redis;
    
use Redis;

use Exporter qw( import );

our @EXPORT_OK = qw(
    extractKeysFromHashRef
    setRedis
    getRedis
);


sub extractKeysFromHashRef {
    my $ref = shift;

    my $idx;
    my @keys = map { $_ } sort { $a cmp $b } keys %$ref;
    return sub {
	for ( @keys ){
	    return $keys[$idx++];
	}
    }
}


sub flattenArrayRefOfHashRefs {
    my $arrayref = shift;

    my @flattened = map { $_, [ @{ %$_ } ] if ref $_ =~ /HASH/ } @$arrayref;

    return \@flattened;
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

