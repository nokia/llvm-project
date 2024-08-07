; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i686-unknown-unknown -mattr=+mmx,+3dnowa -post-RA-scheduler=false | FileCheck %s --check-prefix=NO-POSTRA
; RUN: llc < %s -mtriple=i686-unknown-unknown -mattr=+mmx,+3dnowa -post-RA-scheduler=true | FileCheck %s --check-prefix=POSTRA

define float @PR35982_emms(<1 x i64>) nounwind {
; NO-POSTRA-LABEL: PR35982_emms:
; NO-POSTRA:       # %bb.0:
; NO-POSTRA-NEXT:    subl $8, %esp
; NO-POSTRA-NEXT:    movl {{[0-9]+}}(%esp), %eax
; NO-POSTRA-NEXT:    movq {{[0-9]+}}(%esp), %mm0
; NO-POSTRA-NEXT:    punpckhdq %mm0, %mm0 # mm0 = mm0[1,1]
; NO-POSTRA-NEXT:    movd %mm0, %ecx
; NO-POSTRA-NEXT:    emms
; NO-POSTRA-NEXT:    movl %eax, (%esp)
; NO-POSTRA-NEXT:    fildl (%esp)
; NO-POSTRA-NEXT:    movl %ecx, {{[0-9]+}}(%esp)
; NO-POSTRA-NEXT:    fiaddl {{[0-9]+}}(%esp)
; NO-POSTRA-NEXT:    addl $8, %esp
; NO-POSTRA-NEXT:    retl
;
; POSTRA-LABEL: PR35982_emms:
; POSTRA:       # %bb.0:
; POSTRA-NEXT:    subl $8, %esp
; POSTRA-NEXT:    movq {{[0-9]+}}(%esp), %mm0
; POSTRA-NEXT:    movl {{[0-9]+}}(%esp), %eax
; POSTRA-NEXT:    punpckhdq %mm0, %mm0 # mm0 = mm0[1,1]
; POSTRA-NEXT:    movd %mm0, %ecx
; POSTRA-NEXT:    emms
; POSTRA-NEXT:    movl %eax, (%esp)
; POSTRA-NEXT:    fildl (%esp)
; POSTRA-NEXT:    movl %ecx, {{[0-9]+}}(%esp)
; POSTRA-NEXT:    fiaddl {{[0-9]+}}(%esp)
; POSTRA-NEXT:    addl $8, %esp
; POSTRA-NEXT:    retl
  %2 = bitcast <1 x i64> %0 to <2 x i32>
  %3 = extractelement <2 x i32> %2, i32 0
  %4 = extractelement <1 x i64> %0, i32 0
  %5 = bitcast i64 %4 to <1 x i64>
  %6 = tail call <1 x i64> @llvm.x86.mmx.punpckhdq(<1 x i64> %5, <1 x i64> %5)
  %7 = bitcast <1 x i64> %6 to <2 x i32>
  %8 = extractelement <2 x i32> %7, i32 0
  tail call void @llvm.x86.mmx.emms()
  %9 = sitofp i32 %3 to float
  %10 = sitofp i32 %8 to float
  %11 = fadd float %9, %10
  ret float %11
}

declare <1 x i64> @llvm.x86.mmx.punpckhdq(<1 x i64>, <1 x i64>)
declare void @llvm.x86.mmx.emms()
