#!/usr/bin/perl
use Time::Local;
my $wanted = 'CRON';
my $syslogline = qr/^
  (\S{3})\s{1,2}           # $1 month name
  (\d{1,2})\s              # $2 day of month
  (\d\d):(\d\d):(\d\d)\s   # $3,$4,$5 hour, min, sec
  (\S+)\s                  # $6 host
  ([^[:]+)                 # $7 process name
  (?:\[(\d+)\])?           # $8 process id
  :\s
  (.+)                     # $9 log line
  $/x;
my ($sec,$min,$hour,$mday,$mon,
  $year,$wday,$yday,$dst) = localtime time;
while (<>) {
  if (/$syslogline/) {
    my $time = utctime($1, $2, $3, $4, $5);
    if ($7 eq $wanted) {
      process_line($time,$6,$7,$8,$9);
    }
  }
}
sub utctime {
  my ($mon,$dom,$hour,$min,$sec) = @_;
  my %mons = (
    Jan => 0, Feb => 1, Mar => 2, Apr => 3,
    May => 4, Jun => 5, Jul => 6, Aug => 7,
    Sep => 8, Oct => 9, Nov => 10, Dec => 11,
  );
  my $mod = $mons{$mon};
  return timegm($sec,$min,$hour,$dom,$mod,$year);
}
sub process_line {
  # print join(" ",@_,"\n");
  # ... your code here ...
}

