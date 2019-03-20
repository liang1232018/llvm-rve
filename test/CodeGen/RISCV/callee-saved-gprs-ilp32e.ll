; RUN: llc -mtriple=riscv32 -target-abi ilp32e -verify-machineinstrs < %s \
; RUN:   | FileCheck %s -check-prefix=RV32I
; RUN: llc -mtriple=riscv32  -target-abi ilp32e -verify-machineinstrs -frame-pointer=all < %s \
; RUN:   | FileCheck %s -check-prefix=RV32I-WITH-FP

; RV64I-ILP32E: 32-bit ABIs are not supported for 64-bit targets (ignoring target-abi)
; this is verified by target-abi-invalid.ll

@var = global [32 x i32] zeroinitializer

define void @foo() {
; RV32I-LABEL: foo:
; RV32I:       # %bb.0:
; RV32I-NEXT:    addi sp, sp, -32
; RV32I-NEXT:    sw s0, 28(sp)
; RV32I-NEXT:    sw s1, 24(sp)
; RV32I-NEXT:    lui a0, %hi(var)
; RV32I-NEXT:    addi a1, a0, %lo(var)
;
; RV32I-WITH-FP-LABEL: foo:
; RV32I-WITH-FP:       # %bb.0:
; RV32I-WITH-FP-NEXT:    addi sp, sp, -40
; RV32I-WITH-FP-NEXT:    sw ra, 36(sp)
; RV32I-WITH-FP-NEXT:    sw s0, 32(sp)
; RV32I-WITH-FP-NEXT:    sw s1, 28(sp)
; RV32I-WITH-FP-NEXT:    addi s0, sp, 40
; RV32I-WITH-FP-NEXT:    lui a0, %hi(var)
; RV32I-WITH-FP-NEXT:    addi a1, a0, %lo(var)
  %val = load [32 x i32], [32 x i32]* @var
  store volatile [32 x i32] %val, [32 x i32]* @var
  ret void
}
