
perl -ne 'print "$1 . .\" $1\" cr\n" if /^struct\s+(\w+)/' < raylib_structs.f;
