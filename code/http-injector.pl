#!/usr/bin/perl
use Getopt::Long;
use IO::Socket;
use Time::HiRes qw(sleep);

my %opt = ( delay => 0 );

GetOptions( \%opt, 'delay=i');

my $serv = shift;
my $port   = shift || 80;

my $sock = IO::Socket::INET->new(PeerAddr => $serv,
                                 PeerPort => $port,
                                 Proto    => 'tcp');

my @in = <>;
my $del = $opt{delay} / ( 1.0 + scalar @in );
foreach (@in) {
    s/[\r\n]+$//;
    sleep $del;
    print $sock $_, "\r\n";
}
sleep $del;
print $sock "\r\n";

while (my $line = <$sock>) {
    print $line;
}
