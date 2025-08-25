import re
from collections import defaultdict

print("Hi~")

# 1. IR 함수 플러우기
with open("./llvm-tutor/all_functions.txt") as f:
    ir_funcs = set()
    for line in f:
        if line.startswith("; Function Attrs:") or line.startswith("define "):
            fn = line.strip().split(' ')[-1].strip('()')
            ir_funcs.add(fn)

# 2. real_functions.txt에서 함수 이름과 파일명 추출
func_to_file = defaultdict(list)
declared_funcs = set()
with open("./linux-6.10/real_functions_no_inline.txt") as f:
    for line in f:
        line = line.strip()
        if not line or ":" not in line:
            continue
        filename, code = line.split(':', 1)
        match = re.search(r'\b(\w+)\s*\(', code)
        if match:
            fn = match.group(1)
            declared_funcs.add(fn)
            func_to_file[fn].append(filename.strip())

# 3. 표명 함수 비교
covered = sorted(declared_funcs & ir_funcs)
missing = sorted(declared_funcs - ir_funcs)

# 4. 출력
print(f"✅ Covered: {len(covered)} functions")
print(f"❌ Missing: {len(missing)} functions\n")

if missing:
    for fn in missing:
        files = func_to_file.get(fn, [])
        file_list = ", ".join(files)
        print(f" - {fn} (in {file_list})")

