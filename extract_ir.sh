#!/bin/bash

OUT_DIR="all_llvm_ir"
LOG_DIR="failed_logs"
mkdir -p "$OUT_DIR" "$LOG_DIR"

find . -name '*.o.cmd' | while read -r cmdfile; do
  cfile=$(grep -oP '[^ ]+\.c(?= )' "$cmdfile" | head -n1)
  [[ -f "$cfile" ]] || continue

  llfile="$OUT_DIR/${cfile//\//_}.ll"
  [[ -f "$llfile" ]] && continue

  clang_cmd=$(grep -oP 'cmd_[^:]+: *= .*clang.* -c .*' "$cmdfile" \
    | sed 's/cmd_[^:]*: *= //' \
    | sed 's/ &&.*objtool.*//')

  # IR 생성용으로 -c를 -emit-llvm -S로 바꾸고 -o 제거 후 새로 지정
  clang_cmd=$(echo "$clang_cmd" | sed 's/ -c / -emit-llvm -S /')
  clang_cmd=$(echo "$clang_cmd" | sed -E 's/ -o [^ ]+//g')
  clang_cmd="$clang_cmd -o $llfile"

  echo "[*] $cfile → $llfile"
  if ! eval "$clang_cmd" >/dev/null 2> "$LOG_DIR/$(basename "$llfile").log"; then
    echo "    ↳ Failed to build $llfile (see $LOG_DIR/$(basename "$llfile").log)"
  fi
done

