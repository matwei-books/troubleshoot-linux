#!/bin/sh
progname=$(basename $0)
origin=$0.orig
die () {
  ev=$1
  shift
  echo $* 1>&2
  exit $ev
}
[ -x $origin ] || die 2 "Can't execute $origin"
tmpdir=$(mktemp -d /tmp/$progname.XXXXX)
date > $tmpdir/invocation
echo "#----- args -----" >> $tmpdir/invocation
for arg in "$@"; do
  echo $arg >> $tmpdir/invocation;
done
echo "#----- id -----" >> $tmpdir/invocation
id >> $tmpdir/invocation
echo "#----- env -----" >> $tmpdir/invocation
env >> $tmpdir/invocation
strace -f -o $tmpdir/strace.out $origin "$@"
