SRC_DIR="/root/linux-6.10"
> real_functions.txt

find "$SRC_DIR" -name '*.c' | while read -r file; do
  awk '
    BEGIN {
      in_decl = 0
      decl = ""
      parens = 0
      lineno = 0
    }

    {
      if (in_decl == 0) {
        if ($0 ~ /^[ \t]*[a-zA-Z_][a-zA-Z0-9_ \t\*]*[ \t]+[a-zA-Z_][a-zA-Z0-9_]*[ \t]*\(/) {
          decl = $0
          lineno = NR
          in_decl = 1
          parens = gsub(/\(/, "(", $0) - gsub(/\)/, ")", $0)
          if ($0 ~ /\//) in_decl = 0
        }
      } else {
        decl = decl "\n" $0
        parens = gsub(/\(/, "(", $0) - gsub(/\)/, ")", $0)
        if ($0 ~ /\//) in_decl = 0
      }

      if (in_decl != 0) {
        if ($0 ~ /[{][ \t]*$/) {
          if (decl !~ /inline/) {
            print FILENAME ":" lineno ":" decl
          }
          in_decl = 0
        }
      } else {
        if ($0 ~ /[{][ \t]*$/) {
          if (decl !~ /inline/) {
            print FILENAME ":" lineno ":" decl
          }
          in_decl = 0
        } else {
          getline nextline
          if (nextline ~ /^[ \t]*[{][ \t]*$/) {
            if (decl !~ /inline/) {
              print FILENAME ":" lineno ":" decl
            }
          }
          in_decl = 0
        }
      }
    }
  ' "$file" >> real_functions.txt
done

