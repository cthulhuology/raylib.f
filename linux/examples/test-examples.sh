#!/bin/bash
# Compile-check every Forth example, then smoke-run it with a timeout.
set -u
ROOT=/home/dave/forth/raylib.f/linux
SF=/opt/SwiftForth/bin/linux/sf64
EX=$ROOT/examples
LOG=$EX/test-log.txt
export DISPLAY="${DISPLAY:-:0}"
: >"$LOG"
pass=0
fail=0
skip=0

compile() {
  local f="$1"
  local tmp
  tmp=$(mktemp /tmp/sfexXXXX.f)
  cat >"$tmp" <<EOF
: EXAMPLE-NO-RUN ;
include $EX/common.f
include $f
bye
EOF
  if $SF "$tmp" >>"$LOG" 2>&1; then
    rm -f "$tmp"
    return 0
  fi
  rm -f "$tmp"
  return 1
}

smoke() {
  local f="$1"
  local tmp
  tmp=$(mktemp /tmp/sfexXXXX.f)
  cat >"$tmp" <<EOF
include $EX/common.f
: InitWindow  FLAG_WINDOW_HIDDEN SetConfigFlags  InitWindow ;
include $f
bye
EOF
  timeout 4 $SF "$tmp" >>"$LOG" 2>&1
  local rc=$?
  rm -f "$tmp"
  stty sane < /dev/tty 2>/dev/null || true
  # 124 = timeout (still running = success for a GUI example)
  # 0 = clean exit
  if [ "$rc" = 0 ] || [ "$rc" = 124 ]; then
    return 0
  fi
  return 1
}

while IFS= read -r -d '' f; do
  rel=${f#$EX/}
  printf '%-48s ' "$rel"
  echo "==== $rel ====" >>"$LOG"
  if ! compile "$f"; then
    echo COMPILE-FAIL
    echo COMPILE-FAIL >>"$LOG"
    fail=$((fail+1))
    continue
  fi
  if ! smoke "$f"; then
    echo RUN-FAIL
    echo RUN-FAIL >>"$LOG"
    fail=$((fail+1))
    continue
  fi
  echo OK
  pass=$((pass+1))
done < <(find "$EX" -name '*.f' ! -name common.f ! -name example.f ! -name raymath.f -print0 | sort -z)

echo
echo "Passed: $pass  Failed: $fail"
echo "Log: $LOG"
test "$fail" -eq 0
