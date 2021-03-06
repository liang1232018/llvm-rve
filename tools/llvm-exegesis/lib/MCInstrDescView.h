//===-- MCInstrDescView.h ---------------------------------------*- C++ -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
///
/// \file
/// Provide views around LLVM structures to represents an instruction instance,
/// as well as its implicit and explicit arguments in a uniform way.
/// Arguments that are explicit and independant (non tied) also have a Variable
/// associated to them so the instruction can be fully defined by reading its
/// Variables.
///
//===----------------------------------------------------------------------===//

#ifndef LLVM_TOOLS_LLVM_EXEGESIS_MCINSTRDESCVIEW_H
#define LLVM_TOOLS_LLVM_EXEGESIS_MCINSTRDESCVIEW_H

#include <random>

#include "RegisterAliasing.h"
#include "llvm/ADT/ArrayRef.h"
#include "llvm/ADT/Optional.h"
#include "llvm/MC/MCInst.h"
#include "llvm/MC/MCInstrDesc.h"
#include "llvm/MC/MCInstrInfo.h"

namespace exegesis {

// A variable represents the value associated to an Operand or a set of Operands
// if they are tied together.
struct Variable {
  // Returns the index of this Variable inside Instruction's Variable.
  unsigned getIndex() const;

  // Returns the index of the Operand linked to this Variable.
  unsigned getPrimaryOperandIndex() const;

  // Returns whether this Variable has more than one Operand linked to it.
  bool hasTiedOperands() const;

  // The indices of the operands tied to this Variable.
  llvm::SmallVector<unsigned, 2> TiedOperands;
  llvm::MCOperand AssignedValue;
  // The index of this Variable in Instruction.Variables and its associated
  // Value in InstructionBuilder.VariableValues.
  int Index = -1;
};

// MCOperandInfo can only represents Explicit operands. This object gives a
// uniform view of Implicit and Explicit Operands.
// - Index: can be used to refer to MCInstrDesc::operands for Explicit operands.
// - Tracker: is set for Register Operands and is used to keep track of possible
// registers and the registers reachable from them (aliasing registers).
// - Info: a shortcut for MCInstrDesc::operands()[Index].
// - TiedToIndex: the index of the Operand holding the value or -1.
// - ImplicitReg: a pointer to the register value when Operand is Implicit,
// nullptr otherwise.
// - VariableIndex: the index of the Variable holding the value for this Operand
// or -1 if this operand is implicit.
struct Operand {
  bool getIndex() const;
  bool isExplicit() const;
  bool isImplicit() const;
  bool isImplicitReg() const;
  bool isDef() const;
  bool isUse() const;
  bool isReg() const;
  bool isTied() const;
  bool isVariable() const;
  bool isMemory() const;
  bool isImmediate() const;
  int getTiedToIndex() const;
  int getVariableIndex() const;
  unsigned getImplicitReg() const;
  const RegisterAliasingTracker &getRegisterAliasing() const;
  const llvm::MCOperandInfo &getExplicitOperandInfo() const;

  // Please use the accessors above and not the following fields.
  unsigned Index = 0;
  bool IsDef = false;
  const RegisterAliasingTracker *Tracker = nullptr; // Set for Register Op.
  const llvm::MCOperandInfo *Info = nullptr;        // Set for Explicit Op.
  int TiedToIndex = -1;                             // Set for Reg&Explicit Op.
  const llvm::MCPhysReg *ImplicitReg = nullptr;     // Set for Implicit Op.
  int VariableIndex = -1;                           // Set for Explicit Op.
};

// A view over an MCInstrDesc offering a convenient interface to compute
// Register aliasing.
struct Instruction {
  Instruction(const llvm::MCInstrDesc &MCInstrDesc,
              const RegisterAliasingTrackerCache &ATC);

  // Returns the Operand linked to this Variable.
  // In case the Variable is tied, the primary (i.e. Def) Operand is returned.
  const Operand &getPrimaryOperand(const Variable &Var) const;

  // Returns whether this instruction has Memory Operands.
  // Repeating this instruction executes sequentially with an instruction that
  // reads or write the same memory region.
  bool hasMemoryOperands() const;

  // Whether this instruction is self aliasing through its implicit registers.
  // Repeating this instruction is guaranteed to executes sequentially.
  bool hasAliasingImplicitRegisters() const;

  // Whether this instruction is self aliasing through its tied registers.
  // Repeating this instruction is guaranteed to executes sequentially.
  bool hasTiedRegisters() const;

  // Whether this instruction is self aliasing through some registers.
  // Repeating this instruction may execute sequentially by picking aliasing
  // Use and Def registers. It may also execute in parallel by picking non
  // aliasing Use and Def registers.
  bool hasAliasingRegisters() const;

  const llvm::MCInstrDesc *Description; // Never nullptr.
  llvm::SmallVector<Operand, 8> Operands;
  llvm::SmallVector<Variable, 4> Variables;
  llvm::BitVector ImplDefRegs; // The set of aliased implicit def registers.
  llvm::BitVector ImplUseRegs; // The set of aliased implicit use registers.
  llvm::BitVector AllDefRegs;  // The set of all aliased def registers.
  llvm::BitVector AllUseRegs;  // The set of all aliased use registers.
};

// Represents the assignment of a Register to an Operand.
struct RegisterOperandAssignment {
  RegisterOperandAssignment(const Operand *Operand, llvm::MCPhysReg Reg)
      : Op(Operand), Reg(Reg) {}

  const Operand *Op; // Pointer to an Explicit Register Operand.
  llvm::MCPhysReg Reg;

  bool operator==(const RegisterOperandAssignment &other) const;
};

// Represents a set of Operands that would alias through the use of some
// Registers.
// There are two reasons why operands would alias:
// - The registers assigned to each of the operands are the same or alias each
//   other (e.g. AX/AL)
// - The operands are tied.
struct AliasingRegisterOperands {
  llvm::SmallVector<RegisterOperandAssignment, 1> Defs; // Unlikely size() > 1.
  llvm::SmallVector<RegisterOperandAssignment, 2> Uses;

  // True is Defs and Use contain an Implicit Operand.
  bool hasImplicitAliasing() const;

  bool operator==(const AliasingRegisterOperands &other) const;
};

// Returns all possible configurations leading Def registers of DefInstruction
// to alias with Use registers of UseInstruction.
struct AliasingConfigurations {
  AliasingConfigurations(const Instruction &DefInstruction,
                         const Instruction &UseInstruction);

  bool empty() const; // True if no aliasing configuration is found.
  bool hasImplicitAliasing() const;
  void setExplicitAliasing() const;

  const Instruction &DefInstruction;
  const Instruction &UseInstruction;
  llvm::SmallVector<AliasingRegisterOperands, 32> Configurations;
};

// Writes MCInst to OS.
// This is not assembly but the internal LLVM's name for instructions and
// registers.
void DumpMCInst(const llvm::MCRegisterInfo &MCRegisterInfo,
                const llvm::MCInstrInfo &MCInstrInfo,
                const llvm::MCInst &MCInst, llvm::raw_ostream &OS);

} // namespace exegesis

#endif // LLVM_TOOLS_LLVM_EXEGESIS_MCINSTRDESCVIEW_H
