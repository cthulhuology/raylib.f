perl -ne 'print "{\"$1\", sizeof(struct $1)},\n" if /^struct\s+(\w+)/' < raylib_structs.f;
