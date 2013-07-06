#!/usr/bin/perl
use Getopt::Long;
use IO::Socket;
use Time::HiRes qw(sleep);

my %opt = ( delay => 0 );

GetOptions( \%opt, 'delay=i');

my $server = shift;
my $port   = shift || 80;

my $socket = IO::Socket::INET->new(PeerAddr => $server,
                                   PeerPort => $port,
                                   Proto    => 'tcp',
                                   Type     => SOCK_STREAM);

my @in = <>;
my $del = $opt{delay} / ( 1.0 + scalar @in );
foreach (@in) {
    s/[\r\n]+$//;
    sleep $del;
    print $socket $_, "\r\n";
}
sleep $del;
print $socket "\r\n";

while (my $line = <$socket>) {
    print $line;
}
