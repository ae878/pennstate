#include "llvm/IR/Function.h"
#include "llvm/IR/PassManager.h"
#include "llvm/IR/Metadata.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/Passes/PassBuilder.h"
#include "llvm/Passes/PassPlugin.h"

using namespace llvm;

namespace {
    struct AddNotePass : public PassInfoMixin<AddNotePass> {
        PreservedAnalyses run(Function &F, FunctionAnalysisManager &) {
            LLVMContext &Ctx = F.getContext();
            MDNode *Note = MDNode::get(Ctx, MDString::get(Ctx, "NOTE: Inserted by AddNotePass"));
            F.setMetadata("mynote", Note);
            errs() << "AddNotePass: Metadata added to function: " << F.getName() << "\n";
            return PreservedAnalyses::all();
        }
    };
}

extern "C" LLVM_ATTRIBUTE_WEAK ::llvm::PassPluginLibraryInfo llvmGetPassPluginInfo() {
    return {
        LLVM_PLUGIN_API_VERSION, "AddNotePass", "v0.1",
        [](PassBuilder &PB) {
            PB.registerPipelineParsingCallback(
                [](StringRef Name, FunctionPassManager &FPM,
                   ArrayRef<PassBuilder::PipelineElement>) {
                    if (Name == "add-note") {
                        FPM.addPass(AddNotePass());
                        return true;
                    }
                    return false;
                }
            );
        }
    };
}

