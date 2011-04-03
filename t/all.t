use strict;
use warnings FATAL => "all";
use Test::More;

plan skip_all => "This only works on Linux" unless $^O eq "linux";
plan 'no_plan';

use_ok 'Linux::Smaps::Tiny';

my $smaps = Linux::Smaps::Tiny::get_smaps_summary();
cmp_ok(ref($smaps), "eq", "HASH", "We got a hash back");

my @fields = qw(
    KernelPageSize
    MMUPageSize
    Private_Clean
    Private_Dirty
    Pss
    Referenced
    Rss
    Shared_Clean
    Shared_Dirty
    Size
    Swap
);

for my $thing (@fields) {
    ok(exists $smaps->{$thing}, "The $thing entry exists");
}

eval {
    Linux::Smaps::Tiny::get_smaps_summary("HELLO THERE");
    1;
};
my $err = $@;
like($err, qr/HELLO THERE.*\[2\].*No such file or directory at/, "Sensible error messages");
