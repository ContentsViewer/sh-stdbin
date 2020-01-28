#! /bin/sh

######################################################################
#
# NL - The "nl" Command Also On Just A POSIX Environment
#
# USAGE: nl [--by-myself] 
#
#        --by-myself . (write as the 1st argument when use)
#                        Not use the "built-in" nl command
#                        and always do nl by myself but it is
#                        inferior to the built-in in performance
#
######################################################################


######################################################################
# Initial Configuration
######################################################################


# === Initialize shell environment ===================================
set -u
umask 0222  # not alow to write
export LC_ALL=C
type command >/dev/null 2>&1 && type getconf >/dev/null 2>&1 &&
export PATH="$(command -p getconf PATH)${PATH+:}${PATH-}"
export UNIX_STD=2003  # to make HP-UX conform to POSIX


######################################################################
# Argument Parsing
######################################################################

# === Exec the built-in nl command if OK and exists ===============
by_myself=0
case "${1:-}" in
  '--by-myself')
     shift; by_myself=1
     ;;
  *) export mydir=$(d=${0%/*}/;[ "_$d" = "_$0/" ]||cd "$d";echo "$(pwd)")
     path0=${PATH:-}
     PATH=$(printf  '%s\n' "$path0"      |
            tr      ':' '\n'             |
            awk     '$0!=ENVIRON["mydir"]{print;}' |
            tr      '\n' ':'                       |
            grep -v '^:$'                          |
            sed     's/:$//'                       )
     CMD_builtin=$(command -v nl 2>/dev/null || :)
     case "$CMD_builtin" in '') by_myself=1;; esac
     PATH=$path0
     unset mydir
     ;;
esac
case $by_myself in 0) exec "$CMD_builtin" ${1+"$@"}; exet 1;; esac


######################################################################
# Main Routine
######################################################################

awk '{printf("%6d\t%s\n",NR,$0);}'
