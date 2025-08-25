kasan_toggle_diff.sh: A Linux kernel build script that checks the differences when the CONFIG_KASAN option is enabled vs disabled. It first builds the kernel with the default configuration, then once with CONFIG_KASAN enabled and once with it disabled, saving the outputs. Finally, it runs diff to compare the results. This makes it possible to see what changes in certain files depending on the presence of the KASAN option.

AddNotePass.cpp: An example LLVM Function Pass. It inserts metadata "NOTE: Inserted by AddNotePass" into each function in the IR and prints out which functions received the metadata. The pass can be invoked in the pipeline using the -passes=add-note option, and serves as a minimal example of how an LLVM pass plugin is structured.

gen_llvm_ir.sh: A script that extracts clang build commands from kernel build .o.cmd files and generates .ll LLVM IR files. It replaces the -c option with -emit-llvm -S, removes the old output flag, and specifies a new .ll output file path. If the conversion fails, logs are stored separately.

clang_ir_gen.sh: Similar to gen_llvm_ir.sh, but instead directly extracts the clang portion from lines matching the cmd_... := clang ... pattern. It removes objtool-related commands and generates .ll output files based on .c source file names. It also saves logs on failure, with the same goal of producing IR.

compare_ir_funcs.py: A Python script that compares the list of functions recorded in LLVM IR against the list of functions declared in kernel source files. It collects IR functions from all_functions.txt, and extracts function names and filenames from real_functions_no_inline.txt. It then compares the two sets, reporting which functions are covered in the IR and which are missing, along with the source files where the missing ones are declared.

run_pass.sh: A script that uses the opt tool to apply a specific LLVM Pass plugin (libHelloWorld.so) across multiple IR files. It iterates over all .ll files in a given directory, running -passes=hello-world on each file, and prints the results to the console. Useful for batch testing a custom LLVM pass on a large set of IR files.
