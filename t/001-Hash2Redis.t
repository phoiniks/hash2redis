use strict;
use warnings;
use diagnostics;

use Data::Dump qw( dump );

use FindBin qw( $Bin );

use lib "$Bin/../lib";

use Test::More;
use Test::Differences;
use Test::Deep;

my @subs = qw(
    extractKeysFromHashRef
    extractValuesFromHashRef
    hashref2arrayref
    setRedis
    getRedis
);


my $hashref = {
    TEST1 => {
	test1 => 'BLÖD',
	test2 => 'DOOF',
	test3 => 'BESCHEUERT' },
    TEST2 => {
	test4 => 'HOLLERADUDÖDLDU',
	test5 => 'ZICKEZACKEHÜHNERKACKE',
	test6 => 'WASNDUDAPPHAUABBNDUSAU' },
    TEST3 => {
	test7 => 'Nuria Acacio López',
	test8 => 'Laura Grell Acacio',
	test9 => 'Andreas Grell',
	test10 => 'Francisco Pizarro'
    }
};


use_ok( 'Hash2Redis', @subs );
can_ok( __PACKAGE__, 'extractKeysFromHashRef' );
can_ok( __PACKAGE__, 'extractValuesFromHashRef' );
can_ok( __PACKAGE__, 'hashref2arrayref' );
can_ok( __PACKAGE__, 'setRedis' );
can_ok( __PACKAGE__, 'getRedis' );

my $iterator = extractKeysFromHashRef( $hashref );

my $key = $iterator->();
is( $key, 'TEST1', 'Hash-Schlüssel Nr. 1 - wie erwartet.' );

$key = $iterator->();
is( $key, 'TEST2', 'Hash-Schlüssel Nr. 2 - wie erwartet.' );

$key = $iterator->();
is( $key, 'TEST3', 'Hash-Schlüssel Nr. 3 - wie erwartet.' );

$iterator = extractValuesFromHashRef( $hashref );

my $value = $iterator->();
like( ref $value, qr/HASH/, 'Nr. 1: Referenz auf Hash.' );
eq_or_diff( $value, { test1 => 'BLÖD', test2 => 'DOOF', test3 => 'BESCHEUERT' }, 'Inhalt von Hash-Wert Nr. 1 - wie erwartet.' );
isnt( $value, { test1 => 'BLOED', test2 => 'DOOF', test3 => 'BESCHEUERT' }, 'Inhalt von Hash-Wert Nr. 1 - nicht wie erwartet.' );

$value = $iterator->();
like( ref $value, qr/HASH/, 'Nr. 2: Referenz auf Hash.' );
eq_or_diff( $value, { test4 => 'HOLLERADUDÖDLDU', test5 => 'ZICKEZACKEHÜHNERKACKE', test6 => 'WASNDUDAPPHAUABBNDUSAU' }, 'Inhalt von Hash-Wert Nr. 2 - wie erwartet.' );
isnt( $value, { test4 => 'HOLLERADUDÖDLDU', test5 => 'ZICKEZACKEHÜHNERKACKE', test6 => 'WASNDUDAPPHAUABNDUSAU' }, 'Inhalt von Hash-Wert Nr. 2 - nicht wie erwartet.' );

$value = $iterator->();
like( ref $value, qr/HASH/, 'Nr. 3: Referenz auf Hash.' );
eq_or_diff( $value, { test7 => 'Nuria Acacio López', test8 => 'Laura Grell Acacio', test9 => 'Andreas Grell', test10 => 'Francisco Pizarro' }, 'Inhalt Hash-Wert Nr. 3 - wie erwartet.' );
isnt( $value, { test7 => 'Nuria Acacio Lopez', test8 => 'Laura Grell Acacio', test9 => 'Andreas Grell', test10 => 'Francisco Pizarro' }, 'Inhalt Hash-Wert Nr. 3 - nicht wie erwartet.' );

my $desc = 'Hash-Referenz nicht erfolgreich in Array-Referenz umgewandelt.'; 
eq_or_diff( hashref2arrayref( $hashref->{ TEST1 } ), [ 'test1', 'BLÖD', 'test2', 'DOOF', 'test3', 'BESCHEUERT' ], 'Hash-Referenz erfolgreich in Array-Referenz umgewandelt.' );
isnt( hashref2arrayref( $hashref->{ TEST1 } ), [ 'test1', 'BLÖD', 'test2', 'DOOF', 'test3', 'BESCHOIERT' ], $desc );
isnt( hashref2arrayref( $hashref->{ TEST2 } ), [ 'test1', 'BLÖD', 'test2', 'DOOF', 'test3', 'BESCHOIERT' ], $desc );
isnt( hashref2arrayref( $hashref->{ TEST3 } ), [ 'test1', 'BLÖD', 'test2', 'DOOF', 'test3', 'BESCHOIERT' ], $desc );


done_testing();
