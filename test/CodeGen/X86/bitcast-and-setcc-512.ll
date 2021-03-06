; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+sse4.2 | FileCheck %s --check-prefixes=SSE
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx | FileCheck %s --check-prefixes=AVX12,AVX1
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx2 | FileCheck %s --check-prefixes=AVX12,AVX2
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx512f | FileCheck %s --check-prefix=AVX512 --check-prefix=AVX512F
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx512f,+avx512bw | FileCheck %s --check-prefix=AVX512 --check-prefix=AVX512BW

define i8 @v8i64(<8 x i64> %a, <8 x i64> %b, <8 x i64> %c, <8 x i64> %d) {
; SSE-LABEL: v8i64:
; SSE:       # %bb.0:
; SSE-NEXT:    movdqa {{[0-9]+}}(%rsp), %xmm8
; SSE-NEXT:    movdqa {{[0-9]+}}(%rsp), %xmm9
; SSE-NEXT:    movdqa {{[0-9]+}}(%rsp), %xmm10
; SSE-NEXT:    movdqa {{[0-9]+}}(%rsp), %xmm11
; SSE-NEXT:    pcmpgtq %xmm7, %xmm3
; SSE-NEXT:    pshufd {{.*#+}} xmm3 = xmm3[0,2,2,3]
; SSE-NEXT:    pshuflw {{.*#+}} xmm3 = xmm3[0,1,0,2,4,5,6,7]
; SSE-NEXT:    pcmpgtq %xmm6, %xmm2
; SSE-NEXT:    pshufd {{.*#+}} xmm2 = xmm2[0,2,2,3]
; SSE-NEXT:    pshuflw {{.*#+}} xmm2 = xmm2[0,1,0,2,4,5,6,7]
; SSE-NEXT:    punpckldq {{.*#+}} xmm2 = xmm2[0],xmm3[0],xmm2[1],xmm3[1]
; SSE-NEXT:    pcmpgtq %xmm5, %xmm1
; SSE-NEXT:    pshufd {{.*#+}} xmm1 = xmm1[0,2,2,3]
; SSE-NEXT:    pshuflw {{.*#+}} xmm1 = xmm1[0,2,2,3,4,5,6,7]
; SSE-NEXT:    pcmpgtq %xmm4, %xmm0
; SSE-NEXT:    pshufd {{.*#+}} xmm0 = xmm0[0,2,2,3]
; SSE-NEXT:    pshuflw {{.*#+}} xmm0 = xmm0[0,2,2,3,4,5,6,7]
; SSE-NEXT:    punpckldq {{.*#+}} xmm0 = xmm0[0],xmm1[0],xmm0[1],xmm1[1]
; SSE-NEXT:    pblendw {{.*#+}} xmm0 = xmm0[0,1,2,3],xmm2[4,5,6,7]
; SSE-NEXT:    pcmpgtq {{[0-9]+}}(%rsp), %xmm11
; SSE-NEXT:    pshufd {{.*#+}} xmm1 = xmm11[0,2,2,3]
; SSE-NEXT:    pshuflw {{.*#+}} xmm1 = xmm1[0,1,0,2,4,5,6,7]
; SSE-NEXT:    pcmpgtq {{[0-9]+}}(%rsp), %xmm10
; SSE-NEXT:    pshufd {{.*#+}} xmm2 = xmm10[0,2,2,3]
; SSE-NEXT:    pshuflw {{.*#+}} xmm2 = xmm2[0,1,0,2,4,5,6,7]
; SSE-NEXT:    punpckldq {{.*#+}} xmm2 = xmm2[0],xmm1[0],xmm2[1],xmm1[1]
; SSE-NEXT:    pcmpgtq {{[0-9]+}}(%rsp), %xmm9
; SSE-NEXT:    pshufd {{.*#+}} xmm1 = xmm9[0,2,2,3]
; SSE-NEXT:    pshuflw {{.*#+}} xmm1 = xmm1[0,2,2,3,4,5,6,7]
; SSE-NEXT:    pcmpgtq {{[0-9]+}}(%rsp), %xmm8
; SSE-NEXT:    pshufd {{.*#+}} xmm3 = xmm8[0,2,2,3]
; SSE-NEXT:    pshuflw {{.*#+}} xmm3 = xmm3[0,2,2,3,4,5,6,7]
; SSE-NEXT:    punpckldq {{.*#+}} xmm3 = xmm3[0],xmm1[0],xmm3[1],xmm1[1]
; SSE-NEXT:    pblendw {{.*#+}} xmm3 = xmm3[0,1,2,3],xmm2[4,5,6,7]
; SSE-NEXT:    pand %xmm0, %xmm3
; SSE-NEXT:    packsswb %xmm0, %xmm3
; SSE-NEXT:    pmovmskb %xmm3, %eax
; SSE-NEXT:    # kill: def $al killed $al killed $eax
; SSE-NEXT:    retq
;
; AVX1-LABEL: v8i64:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vextractf128 $1, %ymm3, %xmm8
; AVX1-NEXT:    vextractf128 $1, %ymm1, %xmm9
; AVX1-NEXT:    vpcmpgtq %xmm8, %xmm9, %xmm8
; AVX1-NEXT:    vpcmpgtq %xmm3, %xmm1, %xmm1
; AVX1-NEXT:    vpackssdw %xmm8, %xmm1, %xmm8
; AVX1-NEXT:    vextractf128 $1, %ymm2, %xmm3
; AVX1-NEXT:    vextractf128 $1, %ymm0, %xmm1
; AVX1-NEXT:    vpcmpgtq %xmm3, %xmm1, %xmm1
; AVX1-NEXT:    vpcmpgtq %xmm2, %xmm0, %xmm0
; AVX1-NEXT:    vpackssdw %xmm1, %xmm0, %xmm0
; AVX1-NEXT:    vpackssdw %xmm8, %xmm0, %xmm0
; AVX1-NEXT:    vextractf128 $1, %ymm7, %xmm1
; AVX1-NEXT:    vextractf128 $1, %ymm5, %xmm2
; AVX1-NEXT:    vpcmpgtq %xmm1, %xmm2, %xmm1
; AVX1-NEXT:    vpcmpgtq %xmm7, %xmm5, %xmm2
; AVX1-NEXT:    vpackssdw %xmm1, %xmm2, %xmm1
; AVX1-NEXT:    vextractf128 $1, %ymm6, %xmm2
; AVX1-NEXT:    vextractf128 $1, %ymm4, %xmm3
; AVX1-NEXT:    vpcmpgtq %xmm2, %xmm3, %xmm2
; AVX1-NEXT:    vpcmpgtq %xmm6, %xmm4, %xmm3
; AVX1-NEXT:    vpackssdw %xmm2, %xmm3, %xmm2
; AVX1-NEXT:    vpackssdw %xmm1, %xmm2, %xmm1
; AVX1-NEXT:    vpand %xmm1, %xmm0, %xmm0
; AVX1-NEXT:    vpsllw $15, %xmm0, %xmm0
; AVX1-NEXT:    vpsraw $15, %xmm0, %xmm0
; AVX1-NEXT:    vpacksswb %xmm0, %xmm0, %xmm0
; AVX1-NEXT:    vpmovmskb %xmm0, %eax
; AVX1-NEXT:    # kill: def $al killed $al killed $eax
; AVX1-NEXT:    vzeroupper
; AVX1-NEXT:    retq
;
; AVX2-LABEL: v8i64:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vpcmpgtq %ymm3, %ymm1, %ymm1
; AVX2-NEXT:    vextracti128 $1, %ymm1, %xmm3
; AVX2-NEXT:    vpackssdw %xmm3, %xmm1, %xmm1
; AVX2-NEXT:    vpcmpgtq %ymm2, %ymm0, %ymm0
; AVX2-NEXT:    vextracti128 $1, %ymm0, %xmm2
; AVX2-NEXT:    vpackssdw %xmm2, %xmm0, %xmm0
; AVX2-NEXT:    vpackssdw %xmm1, %xmm0, %xmm0
; AVX2-NEXT:    vpcmpgtq %ymm7, %ymm5, %ymm1
; AVX2-NEXT:    vextracti128 $1, %ymm1, %xmm2
; AVX2-NEXT:    vpackssdw %xmm2, %xmm1, %xmm1
; AVX2-NEXT:    vpcmpgtq %ymm6, %ymm4, %ymm2
; AVX2-NEXT:    vextracti128 $1, %ymm2, %xmm3
; AVX2-NEXT:    vpackssdw %xmm3, %xmm2, %xmm2
; AVX2-NEXT:    vpackssdw %xmm1, %xmm2, %xmm1
; AVX2-NEXT:    vpand %xmm1, %xmm0, %xmm0
; AVX2-NEXT:    vpsllw $15, %xmm0, %xmm0
; AVX2-NEXT:    vpsraw $15, %xmm0, %xmm0
; AVX2-NEXT:    vpacksswb %xmm0, %xmm0, %xmm0
; AVX2-NEXT:    vpmovmskb %xmm0, %eax
; AVX2-NEXT:    # kill: def $al killed $al killed $eax
; AVX2-NEXT:    vzeroupper
; AVX2-NEXT:    retq
;
; AVX512F-LABEL: v8i64:
; AVX512F:       # %bb.0:
; AVX512F-NEXT:    vpcmpgtq %zmm1, %zmm0, %k1
; AVX512F-NEXT:    vpcmpgtq %zmm3, %zmm2, %k0 {%k1}
; AVX512F-NEXT:    kmovw %k0, %eax
; AVX512F-NEXT:    # kill: def $al killed $al killed $eax
; AVX512F-NEXT:    vzeroupper
; AVX512F-NEXT:    retq
;
; AVX512BW-LABEL: v8i64:
; AVX512BW:       # %bb.0:
; AVX512BW-NEXT:    vpcmpgtq %zmm1, %zmm0, %k1
; AVX512BW-NEXT:    vpcmpgtq %zmm3, %zmm2, %k0 {%k1}
; AVX512BW-NEXT:    kmovd %k0, %eax
; AVX512BW-NEXT:    # kill: def $al killed $al killed $eax
; AVX512BW-NEXT:    vzeroupper
; AVX512BW-NEXT:    retq
  %x0 = icmp sgt <8 x i64> %a, %b
  %x1 = icmp sgt <8 x i64> %c, %d
  %y = and <8 x i1> %x0, %x1
  %res = bitcast <8 x i1> %y to i8
  ret i8 %res
}

define i8 @v8f64(<8 x double> %a, <8 x double> %b, <8 x double> %c, <8 x double> %d) {
; SSE-LABEL: v8f64:
; SSE:       # %bb.0:
; SSE-NEXT:    movapd {{[0-9]+}}(%rsp), %xmm8
; SSE-NEXT:    movapd {{[0-9]+}}(%rsp), %xmm9
; SSE-NEXT:    movapd {{[0-9]+}}(%rsp), %xmm10
; SSE-NEXT:    movapd {{[0-9]+}}(%rsp), %xmm11
; SSE-NEXT:    cmpltpd %xmm3, %xmm7
; SSE-NEXT:    shufps {{.*#+}} xmm7 = xmm7[0,2,2,3]
; SSE-NEXT:    pshuflw {{.*#+}} xmm3 = xmm7[0,1,0,2,4,5,6,7]
; SSE-NEXT:    cmpltpd %xmm2, %xmm6
; SSE-NEXT:    shufps {{.*#+}} xmm6 = xmm6[0,2,2,3]
; SSE-NEXT:    pshuflw {{.*#+}} xmm2 = xmm6[0,1,0,2,4,5,6,7]
; SSE-NEXT:    punpckldq {{.*#+}} xmm2 = xmm2[0],xmm3[0],xmm2[1],xmm3[1]
; SSE-NEXT:    cmpltpd %xmm1, %xmm5
; SSE-NEXT:    shufps {{.*#+}} xmm5 = xmm5[0,2,2,3]
; SSE-NEXT:    pshuflw {{.*#+}} xmm1 = xmm5[0,2,2,3,4,5,6,7]
; SSE-NEXT:    cmpltpd %xmm0, %xmm4
; SSE-NEXT:    shufps {{.*#+}} xmm4 = xmm4[0,2,2,3]
; SSE-NEXT:    pshuflw {{.*#+}} xmm0 = xmm4[0,2,2,3,4,5,6,7]
; SSE-NEXT:    punpckldq {{.*#+}} xmm0 = xmm0[0],xmm1[0],xmm0[1],xmm1[1]
; SSE-NEXT:    pblendw {{.*#+}} xmm0 = xmm0[0,1,2,3],xmm2[4,5,6,7]
; SSE-NEXT:    cmpltpd {{[0-9]+}}(%rsp), %xmm11
; SSE-NEXT:    shufps {{.*#+}} xmm11 = xmm11[0,2,2,3]
; SSE-NEXT:    pshuflw {{.*#+}} xmm1 = xmm11[0,1,0,2,4,5,6,7]
; SSE-NEXT:    cmpltpd {{[0-9]+}}(%rsp), %xmm10
; SSE-NEXT:    shufps {{.*#+}} xmm10 = xmm10[0,2,2,3]
; SSE-NEXT:    pshuflw {{.*#+}} xmm2 = xmm10[0,1,0,2,4,5,6,7]
; SSE-NEXT:    punpckldq {{.*#+}} xmm2 = xmm2[0],xmm1[0],xmm2[1],xmm1[1]
; SSE-NEXT:    cmpltpd {{[0-9]+}}(%rsp), %xmm9
; SSE-NEXT:    shufps {{.*#+}} xmm9 = xmm9[0,2,2,3]
; SSE-NEXT:    pshuflw {{.*#+}} xmm1 = xmm9[0,2,2,3,4,5,6,7]
; SSE-NEXT:    cmpltpd {{[0-9]+}}(%rsp), %xmm8
; SSE-NEXT:    shufps {{.*#+}} xmm8 = xmm8[0,2,2,3]
; SSE-NEXT:    pshuflw {{.*#+}} xmm3 = xmm8[0,2,2,3,4,5,6,7]
; SSE-NEXT:    punpckldq {{.*#+}} xmm3 = xmm3[0],xmm1[0],xmm3[1],xmm1[1]
; SSE-NEXT:    pblendw {{.*#+}} xmm3 = xmm3[0,1,2,3],xmm2[4,5,6,7]
; SSE-NEXT:    pand %xmm0, %xmm3
; SSE-NEXT:    packsswb %xmm0, %xmm3
; SSE-NEXT:    pmovmskb %xmm3, %eax
; SSE-NEXT:    # kill: def $al killed $al killed $eax
; SSE-NEXT:    retq
;
; AVX12-LABEL: v8f64:
; AVX12:       # %bb.0:
; AVX12-NEXT:    vcmpltpd %ymm1, %ymm3, %ymm1
; AVX12-NEXT:    vextractf128 $1, %ymm1, %xmm3
; AVX12-NEXT:    vpackssdw %xmm3, %xmm1, %xmm1
; AVX12-NEXT:    vcmpltpd %ymm0, %ymm2, %ymm0
; AVX12-NEXT:    vextractf128 $1, %ymm0, %xmm2
; AVX12-NEXT:    vpackssdw %xmm2, %xmm0, %xmm0
; AVX12-NEXT:    vpackssdw %xmm1, %xmm0, %xmm0
; AVX12-NEXT:    vcmpltpd %ymm5, %ymm7, %ymm1
; AVX12-NEXT:    vextractf128 $1, %ymm1, %xmm2
; AVX12-NEXT:    vpackssdw %xmm2, %xmm1, %xmm1
; AVX12-NEXT:    vcmpltpd %ymm4, %ymm6, %ymm2
; AVX12-NEXT:    vextractf128 $1, %ymm2, %xmm3
; AVX12-NEXT:    vpackssdw %xmm3, %xmm2, %xmm2
; AVX12-NEXT:    vpackssdw %xmm1, %xmm2, %xmm1
; AVX12-NEXT:    vpand %xmm1, %xmm0, %xmm0
; AVX12-NEXT:    vpsllw $15, %xmm0, %xmm0
; AVX12-NEXT:    vpsraw $15, %xmm0, %xmm0
; AVX12-NEXT:    vpacksswb %xmm0, %xmm0, %xmm0
; AVX12-NEXT:    vpmovmskb %xmm0, %eax
; AVX12-NEXT:    # kill: def $al killed $al killed $eax
; AVX12-NEXT:    vzeroupper
; AVX12-NEXT:    retq
;
; AVX512F-LABEL: v8f64:
; AVX512F:       # %bb.0:
; AVX512F-NEXT:    vcmpltpd %zmm0, %zmm1, %k1
; AVX512F-NEXT:    vcmpltpd %zmm2, %zmm3, %k0 {%k1}
; AVX512F-NEXT:    kmovw %k0, %eax
; AVX512F-NEXT:    # kill: def $al killed $al killed $eax
; AVX512F-NEXT:    vzeroupper
; AVX512F-NEXT:    retq
;
; AVX512BW-LABEL: v8f64:
; AVX512BW:       # %bb.0:
; AVX512BW-NEXT:    vcmpltpd %zmm0, %zmm1, %k1
; AVX512BW-NEXT:    vcmpltpd %zmm2, %zmm3, %k0 {%k1}
; AVX512BW-NEXT:    kmovd %k0, %eax
; AVX512BW-NEXT:    # kill: def $al killed $al killed $eax
; AVX512BW-NEXT:    vzeroupper
; AVX512BW-NEXT:    retq
  %x0 = fcmp ogt <8 x double> %a, %b
  %x1 = fcmp ogt <8 x double> %c, %d
  %y = and <8 x i1> %x0, %x1
  %res = bitcast <8 x i1> %y to i8
  ret i8 %res
}

define i32 @v32i16(<32 x i16> %a, <32 x i16> %b, <32 x i16> %c, <32 x i16> %d) {
; SSE-LABEL: v32i16:
; SSE:       # %bb.0:
; SSE-NEXT:    movdqa {{[0-9]+}}(%rsp), %xmm8
; SSE-NEXT:    movdqa {{[0-9]+}}(%rsp), %xmm9
; SSE-NEXT:    movdqa {{[0-9]+}}(%rsp), %xmm10
; SSE-NEXT:    movdqa {{[0-9]+}}(%rsp), %xmm11
; SSE-NEXT:    pcmpgtw %xmm5, %xmm1
; SSE-NEXT:    pcmpgtw %xmm4, %xmm0
; SSE-NEXT:    packsswb %xmm1, %xmm0
; SSE-NEXT:    pcmpgtw %xmm7, %xmm3
; SSE-NEXT:    pcmpgtw %xmm6, %xmm2
; SSE-NEXT:    packsswb %xmm3, %xmm2
; SSE-NEXT:    pcmpgtw {{[0-9]+}}(%rsp), %xmm11
; SSE-NEXT:    pcmpgtw {{[0-9]+}}(%rsp), %xmm10
; SSE-NEXT:    packsswb %xmm11, %xmm10
; SSE-NEXT:    pand %xmm0, %xmm10
; SSE-NEXT:    pcmpgtw {{[0-9]+}}(%rsp), %xmm9
; SSE-NEXT:    pcmpgtw {{[0-9]+}}(%rsp), %xmm8
; SSE-NEXT:    packsswb %xmm9, %xmm8
; SSE-NEXT:    pand %xmm2, %xmm8
; SSE-NEXT:    pmovmskb %xmm10, %ecx
; SSE-NEXT:    pmovmskb %xmm8, %eax
; SSE-NEXT:    shll $16, %eax
; SSE-NEXT:    orl %ecx, %eax
; SSE-NEXT:    retq
;
; AVX1-LABEL: v32i16:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vextractf128 $1, %ymm3, %xmm8
; AVX1-NEXT:    vextractf128 $1, %ymm1, %xmm9
; AVX1-NEXT:    vpcmpgtw %xmm8, %xmm9, %xmm8
; AVX1-NEXT:    vpcmpgtw %xmm3, %xmm1, %xmm1
; AVX1-NEXT:    vpacksswb %xmm8, %xmm1, %xmm8
; AVX1-NEXT:    vextractf128 $1, %ymm2, %xmm3
; AVX1-NEXT:    vextractf128 $1, %ymm0, %xmm1
; AVX1-NEXT:    vpcmpgtw %xmm3, %xmm1, %xmm1
; AVX1-NEXT:    vpcmpgtw %xmm2, %xmm0, %xmm0
; AVX1-NEXT:    vpacksswb %xmm1, %xmm0, %xmm0
; AVX1-NEXT:    vextractf128 $1, %ymm7, %xmm1
; AVX1-NEXT:    vextractf128 $1, %ymm5, %xmm2
; AVX1-NEXT:    vpcmpgtw %xmm1, %xmm2, %xmm1
; AVX1-NEXT:    vpcmpgtw %xmm7, %xmm5, %xmm2
; AVX1-NEXT:    vpacksswb %xmm1, %xmm2, %xmm1
; AVX1-NEXT:    vpand %xmm1, %xmm8, %xmm1
; AVX1-NEXT:    vextractf128 $1, %ymm6, %xmm2
; AVX1-NEXT:    vextractf128 $1, %ymm4, %xmm3
; AVX1-NEXT:    vpcmpgtw %xmm2, %xmm3, %xmm2
; AVX1-NEXT:    vpcmpgtw %xmm6, %xmm4, %xmm3
; AVX1-NEXT:    vpacksswb %xmm2, %xmm3, %xmm2
; AVX1-NEXT:    vpand %xmm2, %xmm0, %xmm0
; AVX1-NEXT:    vpmovmskb %xmm0, %ecx
; AVX1-NEXT:    vpmovmskb %xmm1, %eax
; AVX1-NEXT:    shll $16, %eax
; AVX1-NEXT:    orl %ecx, %eax
; AVX1-NEXT:    vzeroupper
; AVX1-NEXT:    retq
;
; AVX2-LABEL: v32i16:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vpcmpgtw %ymm3, %ymm1, %ymm1
; AVX2-NEXT:    vextracti128 $1, %ymm1, %xmm3
; AVX2-NEXT:    vpacksswb %xmm3, %xmm1, %xmm1
; AVX2-NEXT:    vpcmpgtw %ymm2, %ymm0, %ymm0
; AVX2-NEXT:    vextracti128 $1, %ymm0, %xmm2
; AVX2-NEXT:    vpacksswb %xmm2, %xmm0, %xmm0
; AVX2-NEXT:    vinserti128 $1, %xmm1, %ymm0, %ymm0
; AVX2-NEXT:    vpcmpgtw %ymm7, %ymm5, %ymm1
; AVX2-NEXT:    vextracti128 $1, %ymm1, %xmm2
; AVX2-NEXT:    vpacksswb %xmm2, %xmm1, %xmm1
; AVX2-NEXT:    vpcmpgtw %ymm6, %ymm4, %ymm2
; AVX2-NEXT:    vextracti128 $1, %ymm2, %xmm3
; AVX2-NEXT:    vpacksswb %xmm3, %xmm2, %xmm2
; AVX2-NEXT:    vinserti128 $1, %xmm1, %ymm2, %ymm1
; AVX2-NEXT:    vpand %ymm1, %ymm0, %ymm0
; AVX2-NEXT:    vpmovmskb %ymm0, %eax
; AVX2-NEXT:    vzeroupper
; AVX2-NEXT:    retq
;
; AVX512F-LABEL: v32i16:
; AVX512F:       # %bb.0:
; AVX512F-NEXT:    vpcmpgtw %ymm3, %ymm1, %ymm1
; AVX512F-NEXT:    vpmovsxwd %ymm1, %zmm1
; AVX512F-NEXT:    vptestmd %zmm1, %zmm1, %k1
; AVX512F-NEXT:    vpcmpgtw %ymm2, %ymm0, %ymm0
; AVX512F-NEXT:    vpmovsxwd %ymm0, %zmm0
; AVX512F-NEXT:    vptestmd %zmm0, %zmm0, %k2
; AVX512F-NEXT:    vpcmpgtw %ymm7, %ymm5, %ymm0
; AVX512F-NEXT:    vpmovsxwd %ymm0, %zmm0
; AVX512F-NEXT:    vpcmpgtw %ymm6, %ymm4, %ymm1
; AVX512F-NEXT:    vpmovsxwd %ymm1, %zmm1
; AVX512F-NEXT:    vptestmd %zmm1, %zmm1, %k0 {%k2}
; AVX512F-NEXT:    kmovw %k0, %ecx
; AVX512F-NEXT:    vptestmd %zmm0, %zmm0, %k0 {%k1}
; AVX512F-NEXT:    kmovw %k0, %eax
; AVX512F-NEXT:    shll $16, %eax
; AVX512F-NEXT:    orl %ecx, %eax
; AVX512F-NEXT:    vzeroupper
; AVX512F-NEXT:    retq
;
; AVX512BW-LABEL: v32i16:
; AVX512BW:       # %bb.0:
; AVX512BW-NEXT:    vpcmpgtw %zmm1, %zmm0, %k1
; AVX512BW-NEXT:    vpcmpgtw %zmm3, %zmm2, %k0 {%k1}
; AVX512BW-NEXT:    kmovd %k0, %eax
; AVX512BW-NEXT:    vzeroupper
; AVX512BW-NEXT:    retq
  %x0 = icmp sgt <32 x i16> %a, %b
  %x1 = icmp sgt <32 x i16> %c, %d
  %y = and <32 x i1> %x0, %x1
  %res = bitcast <32 x i1> %y to i32
  ret i32 %res
}

define i16 @v16i32(<16 x i32> %a, <16 x i32> %b, <16 x i32> %c, <16 x i32> %d) {
; SSE-LABEL: v16i32:
; SSE:       # %bb.0:
; SSE-NEXT:    movdqa {{[0-9]+}}(%rsp), %xmm8
; SSE-NEXT:    movdqa {{[0-9]+}}(%rsp), %xmm10
; SSE-NEXT:    movdqa {{[0-9]+}}(%rsp), %xmm9
; SSE-NEXT:    movdqa {{[0-9]+}}(%rsp), %xmm11
; SSE-NEXT:    pcmpgtd %xmm7, %xmm3
; SSE-NEXT:    movdqa {{.*#+}} xmm7 = <u,u,u,u,0,4,8,12,u,u,u,u,u,u,u,u>
; SSE-NEXT:    pshufb %xmm7, %xmm3
; SSE-NEXT:    pcmpgtd %xmm6, %xmm2
; SSE-NEXT:    pshufb %xmm7, %xmm2
; SSE-NEXT:    punpckldq {{.*#+}} xmm2 = xmm2[0],xmm3[0],xmm2[1],xmm3[1]
; SSE-NEXT:    pcmpgtd %xmm5, %xmm1
; SSE-NEXT:    movdqa {{.*#+}} xmm3 = <0,4,8,12,u,u,u,u,u,u,u,u,u,u,u,u>
; SSE-NEXT:    pshufb %xmm3, %xmm1
; SSE-NEXT:    pcmpgtd %xmm4, %xmm0
; SSE-NEXT:    pshufb %xmm3, %xmm0
; SSE-NEXT:    punpckldq {{.*#+}} xmm0 = xmm0[0],xmm1[0],xmm0[1],xmm1[1]
; SSE-NEXT:    pblendw {{.*#+}} xmm0 = xmm0[0,1,2,3],xmm2[4,5,6,7]
; SSE-NEXT:    pcmpgtd {{[0-9]+}}(%rsp), %xmm11
; SSE-NEXT:    pshufb %xmm7, %xmm11
; SSE-NEXT:    pcmpgtd {{[0-9]+}}(%rsp), %xmm9
; SSE-NEXT:    pshufb %xmm7, %xmm9
; SSE-NEXT:    punpckldq {{.*#+}} xmm9 = xmm9[0],xmm11[0],xmm9[1],xmm11[1]
; SSE-NEXT:    pcmpgtd {{[0-9]+}}(%rsp), %xmm10
; SSE-NEXT:    pshufb %xmm3, %xmm10
; SSE-NEXT:    pcmpgtd {{[0-9]+}}(%rsp), %xmm8
; SSE-NEXT:    pshufb %xmm3, %xmm8
; SSE-NEXT:    punpckldq {{.*#+}} xmm8 = xmm8[0],xmm10[0],xmm8[1],xmm10[1]
; SSE-NEXT:    pblendw {{.*#+}} xmm8 = xmm8[0,1,2,3],xmm9[4,5,6,7]
; SSE-NEXT:    pand %xmm0, %xmm8
; SSE-NEXT:    pmovmskb %xmm8, %eax
; SSE-NEXT:    # kill: def $ax killed $ax killed $eax
; SSE-NEXT:    retq
;
; AVX1-LABEL: v16i32:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vextractf128 $1, %ymm3, %xmm8
; AVX1-NEXT:    vextractf128 $1, %ymm1, %xmm9
; AVX1-NEXT:    vpcmpgtd %xmm8, %xmm9, %xmm8
; AVX1-NEXT:    vpcmpgtd %xmm3, %xmm1, %xmm1
; AVX1-NEXT:    vpackssdw %xmm8, %xmm1, %xmm8
; AVX1-NEXT:    vextractf128 $1, %ymm2, %xmm3
; AVX1-NEXT:    vextractf128 $1, %ymm0, %xmm1
; AVX1-NEXT:    vpcmpgtd %xmm3, %xmm1, %xmm1
; AVX1-NEXT:    vpcmpgtd %xmm2, %xmm0, %xmm0
; AVX1-NEXT:    vpackssdw %xmm1, %xmm0, %xmm0
; AVX1-NEXT:    vpacksswb %xmm8, %xmm0, %xmm0
; AVX1-NEXT:    vextractf128 $1, %ymm7, %xmm1
; AVX1-NEXT:    vextractf128 $1, %ymm5, %xmm2
; AVX1-NEXT:    vpcmpgtd %xmm1, %xmm2, %xmm1
; AVX1-NEXT:    vpcmpgtd %xmm7, %xmm5, %xmm2
; AVX1-NEXT:    vpackssdw %xmm1, %xmm2, %xmm1
; AVX1-NEXT:    vextractf128 $1, %ymm6, %xmm2
; AVX1-NEXT:    vextractf128 $1, %ymm4, %xmm3
; AVX1-NEXT:    vpcmpgtd %xmm2, %xmm3, %xmm2
; AVX1-NEXT:    vpcmpgtd %xmm6, %xmm4, %xmm3
; AVX1-NEXT:    vpackssdw %xmm2, %xmm3, %xmm2
; AVX1-NEXT:    vpacksswb %xmm1, %xmm2, %xmm1
; AVX1-NEXT:    vpand %xmm1, %xmm0, %xmm0
; AVX1-NEXT:    vpmovmskb %xmm0, %eax
; AVX1-NEXT:    # kill: def $ax killed $ax killed $eax
; AVX1-NEXT:    vzeroupper
; AVX1-NEXT:    retq
;
; AVX2-LABEL: v16i32:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vpcmpgtd %ymm3, %ymm1, %ymm1
; AVX2-NEXT:    vextracti128 $1, %ymm1, %xmm3
; AVX2-NEXT:    vpackssdw %xmm3, %xmm1, %xmm1
; AVX2-NEXT:    vpcmpgtd %ymm2, %ymm0, %ymm0
; AVX2-NEXT:    vextracti128 $1, %ymm0, %xmm2
; AVX2-NEXT:    vpackssdw %xmm2, %xmm0, %xmm0
; AVX2-NEXT:    vpacksswb %xmm1, %xmm0, %xmm0
; AVX2-NEXT:    vpcmpgtd %ymm7, %ymm5, %ymm1
; AVX2-NEXT:    vextracti128 $1, %ymm1, %xmm2
; AVX2-NEXT:    vpackssdw %xmm2, %xmm1, %xmm1
; AVX2-NEXT:    vpcmpgtd %ymm6, %ymm4, %ymm2
; AVX2-NEXT:    vextracti128 $1, %ymm2, %xmm3
; AVX2-NEXT:    vpackssdw %xmm3, %xmm2, %xmm2
; AVX2-NEXT:    vpacksswb %xmm1, %xmm2, %xmm1
; AVX2-NEXT:    vpand %xmm1, %xmm0, %xmm0
; AVX2-NEXT:    vpmovmskb %xmm0, %eax
; AVX2-NEXT:    # kill: def $ax killed $ax killed $eax
; AVX2-NEXT:    vzeroupper
; AVX2-NEXT:    retq
;
; AVX512F-LABEL: v16i32:
; AVX512F:       # %bb.0:
; AVX512F-NEXT:    vpcmpgtd %zmm1, %zmm0, %k1
; AVX512F-NEXT:    vpcmpgtd %zmm3, %zmm2, %k0 {%k1}
; AVX512F-NEXT:    kmovw %k0, %eax
; AVX512F-NEXT:    # kill: def $ax killed $ax killed $eax
; AVX512F-NEXT:    vzeroupper
; AVX512F-NEXT:    retq
;
; AVX512BW-LABEL: v16i32:
; AVX512BW:       # %bb.0:
; AVX512BW-NEXT:    vpcmpgtd %zmm1, %zmm0, %k1
; AVX512BW-NEXT:    vpcmpgtd %zmm3, %zmm2, %k0 {%k1}
; AVX512BW-NEXT:    kmovd %k0, %eax
; AVX512BW-NEXT:    # kill: def $ax killed $ax killed $eax
; AVX512BW-NEXT:    vzeroupper
; AVX512BW-NEXT:    retq
  %x0 = icmp sgt <16 x i32> %a, %b
  %x1 = icmp sgt <16 x i32> %c, %d
  %y = and <16 x i1> %x0, %x1
  %res = bitcast <16 x i1> %y to i16
  ret i16 %res
}

define i16 @v16f32(<16 x float> %a, <16 x float> %b, <16 x float> %c, <16 x float> %d) {
; SSE-LABEL: v16f32:
; SSE:       # %bb.0:
; SSE-NEXT:    movaps {{[0-9]+}}(%rsp), %xmm8
; SSE-NEXT:    movaps {{[0-9]+}}(%rsp), %xmm10
; SSE-NEXT:    movaps {{[0-9]+}}(%rsp), %xmm9
; SSE-NEXT:    movaps {{[0-9]+}}(%rsp), %xmm11
; SSE-NEXT:    cmpltps %xmm3, %xmm7
; SSE-NEXT:    movdqa {{.*#+}} xmm3 = <u,u,u,u,0,4,8,12,u,u,u,u,u,u,u,u>
; SSE-NEXT:    pshufb %xmm3, %xmm7
; SSE-NEXT:    cmpltps %xmm2, %xmm6
; SSE-NEXT:    pshufb %xmm3, %xmm6
; SSE-NEXT:    punpckldq {{.*#+}} xmm6 = xmm6[0],xmm7[0],xmm6[1],xmm7[1]
; SSE-NEXT:    cmpltps %xmm1, %xmm5
; SSE-NEXT:    movdqa {{.*#+}} xmm1 = <0,4,8,12,u,u,u,u,u,u,u,u,u,u,u,u>
; SSE-NEXT:    pshufb %xmm1, %xmm5
; SSE-NEXT:    cmpltps %xmm0, %xmm4
; SSE-NEXT:    pshufb %xmm1, %xmm4
; SSE-NEXT:    punpckldq {{.*#+}} xmm4 = xmm4[0],xmm5[0],xmm4[1],xmm5[1]
; SSE-NEXT:    pblendw {{.*#+}} xmm4 = xmm4[0,1,2,3],xmm6[4,5,6,7]
; SSE-NEXT:    cmpltps {{[0-9]+}}(%rsp), %xmm11
; SSE-NEXT:    pshufb %xmm3, %xmm11
; SSE-NEXT:    cmpltps {{[0-9]+}}(%rsp), %xmm9
; SSE-NEXT:    pshufb %xmm3, %xmm9
; SSE-NEXT:    punpckldq {{.*#+}} xmm9 = xmm9[0],xmm11[0],xmm9[1],xmm11[1]
; SSE-NEXT:    cmpltps {{[0-9]+}}(%rsp), %xmm10
; SSE-NEXT:    pshufb %xmm1, %xmm10
; SSE-NEXT:    cmpltps {{[0-9]+}}(%rsp), %xmm8
; SSE-NEXT:    pshufb %xmm1, %xmm8
; SSE-NEXT:    punpckldq {{.*#+}} xmm8 = xmm8[0],xmm10[0],xmm8[1],xmm10[1]
; SSE-NEXT:    pblendw {{.*#+}} xmm8 = xmm8[0,1,2,3],xmm9[4,5,6,7]
; SSE-NEXT:    pand %xmm4, %xmm8
; SSE-NEXT:    pmovmskb %xmm8, %eax
; SSE-NEXT:    # kill: def $ax killed $ax killed $eax
; SSE-NEXT:    retq
;
; AVX12-LABEL: v16f32:
; AVX12:       # %bb.0:
; AVX12-NEXT:    vcmpltps %ymm1, %ymm3, %ymm1
; AVX12-NEXT:    vextractf128 $1, %ymm1, %xmm3
; AVX12-NEXT:    vpackssdw %xmm3, %xmm1, %xmm1
; AVX12-NEXT:    vcmpltps %ymm0, %ymm2, %ymm0
; AVX12-NEXT:    vextractf128 $1, %ymm0, %xmm2
; AVX12-NEXT:    vpackssdw %xmm2, %xmm0, %xmm0
; AVX12-NEXT:    vpacksswb %xmm1, %xmm0, %xmm0
; AVX12-NEXT:    vcmpltps %ymm5, %ymm7, %ymm1
; AVX12-NEXT:    vextractf128 $1, %ymm1, %xmm2
; AVX12-NEXT:    vpackssdw %xmm2, %xmm1, %xmm1
; AVX12-NEXT:    vcmpltps %ymm4, %ymm6, %ymm2
; AVX12-NEXT:    vextractf128 $1, %ymm2, %xmm3
; AVX12-NEXT:    vpackssdw %xmm3, %xmm2, %xmm2
; AVX12-NEXT:    vpacksswb %xmm1, %xmm2, %xmm1
; AVX12-NEXT:    vpand %xmm1, %xmm0, %xmm0
; AVX12-NEXT:    vpmovmskb %xmm0, %eax
; AVX12-NEXT:    # kill: def $ax killed $ax killed $eax
; AVX12-NEXT:    vzeroupper
; AVX12-NEXT:    retq
;
; AVX512F-LABEL: v16f32:
; AVX512F:       # %bb.0:
; AVX512F-NEXT:    vcmpltps %zmm0, %zmm1, %k1
; AVX512F-NEXT:    vcmpltps %zmm2, %zmm3, %k0 {%k1}
; AVX512F-NEXT:    kmovw %k0, %eax
; AVX512F-NEXT:    # kill: def $ax killed $ax killed $eax
; AVX512F-NEXT:    vzeroupper
; AVX512F-NEXT:    retq
;
; AVX512BW-LABEL: v16f32:
; AVX512BW:       # %bb.0:
; AVX512BW-NEXT:    vcmpltps %zmm0, %zmm1, %k1
; AVX512BW-NEXT:    vcmpltps %zmm2, %zmm3, %k0 {%k1}
; AVX512BW-NEXT:    kmovd %k0, %eax
; AVX512BW-NEXT:    # kill: def $ax killed $ax killed $eax
; AVX512BW-NEXT:    vzeroupper
; AVX512BW-NEXT:    retq
  %x0 = fcmp ogt <16 x float> %a, %b
  %x1 = fcmp ogt <16 x float> %c, %d
  %y = and <16 x i1> %x0, %x1
  %res = bitcast <16 x i1> %y to i16
  ret i16 %res
}

define i64 @v64i8(<64 x i8> %a, <64 x i8> %b, <64 x i8> %c, <64 x i8> %d) {
; SSE-LABEL: v64i8:
; SSE:       # %bb.0:
; SSE-NEXT:    movdqa {{[0-9]+}}(%rsp), %xmm10
; SSE-NEXT:    movdqa {{[0-9]+}}(%rsp), %xmm11
; SSE-NEXT:    movdqa {{[0-9]+}}(%rsp), %xmm8
; SSE-NEXT:    movdqa {{[0-9]+}}(%rsp), %xmm9
; SSE-NEXT:    pcmpgtb %xmm7, %xmm3
; SSE-NEXT:    pcmpgtb %xmm6, %xmm2
; SSE-NEXT:    pcmpgtb %xmm5, %xmm1
; SSE-NEXT:    pcmpgtb %xmm4, %xmm0
; SSE-NEXT:    pcmpgtb {{[0-9]+}}(%rsp), %xmm9
; SSE-NEXT:    pand %xmm3, %xmm9
; SSE-NEXT:    pcmpgtb {{[0-9]+}}(%rsp), %xmm8
; SSE-NEXT:    pand %xmm2, %xmm8
; SSE-NEXT:    pcmpgtb {{[0-9]+}}(%rsp), %xmm11
; SSE-NEXT:    pand %xmm1, %xmm11
; SSE-NEXT:    pcmpgtb {{[0-9]+}}(%rsp), %xmm10
; SSE-NEXT:    pand %xmm0, %xmm10
; SSE-NEXT:    pmovmskb %xmm10, %eax
; SSE-NEXT:    pmovmskb %xmm11, %ecx
; SSE-NEXT:    shll $16, %ecx
; SSE-NEXT:    orl %eax, %ecx
; SSE-NEXT:    pmovmskb %xmm8, %edx
; SSE-NEXT:    pmovmskb %xmm9, %eax
; SSE-NEXT:    shll $16, %eax
; SSE-NEXT:    orl %edx, %eax
; SSE-NEXT:    shlq $32, %rax
; SSE-NEXT:    orq %rcx, %rax
; SSE-NEXT:    retq
;
; AVX1-LABEL: v64i8:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vextractf128 $1, %ymm3, %xmm8
; AVX1-NEXT:    vextractf128 $1, %ymm1, %xmm9
; AVX1-NEXT:    vpcmpgtb %xmm8, %xmm9, %xmm8
; AVX1-NEXT:    vpcmpgtb %xmm3, %xmm1, %xmm9
; AVX1-NEXT:    vextractf128 $1, %ymm2, %xmm3
; AVX1-NEXT:    vextractf128 $1, %ymm0, %xmm1
; AVX1-NEXT:    vpcmpgtb %xmm3, %xmm1, %xmm1
; AVX1-NEXT:    vpcmpgtb %xmm2, %xmm0, %xmm0
; AVX1-NEXT:    vextractf128 $1, %ymm7, %xmm2
; AVX1-NEXT:    vextractf128 $1, %ymm5, %xmm3
; AVX1-NEXT:    vpcmpgtb %xmm2, %xmm3, %xmm2
; AVX1-NEXT:    vpand %xmm2, %xmm8, %xmm2
; AVX1-NEXT:    vpcmpgtb %xmm7, %xmm5, %xmm3
; AVX1-NEXT:    vpand %xmm3, %xmm9, %xmm3
; AVX1-NEXT:    vextractf128 $1, %ymm6, %xmm5
; AVX1-NEXT:    vextractf128 $1, %ymm4, %xmm7
; AVX1-NEXT:    vpcmpgtb %xmm5, %xmm7, %xmm5
; AVX1-NEXT:    vpand %xmm5, %xmm1, %xmm1
; AVX1-NEXT:    vpcmpgtb %xmm6, %xmm4, %xmm4
; AVX1-NEXT:    vpand %xmm4, %xmm0, %xmm0
; AVX1-NEXT:    vpmovmskb %xmm0, %eax
; AVX1-NEXT:    vpmovmskb %xmm1, %ecx
; AVX1-NEXT:    shll $16, %ecx
; AVX1-NEXT:    orl %eax, %ecx
; AVX1-NEXT:    vpmovmskb %xmm3, %edx
; AVX1-NEXT:    vpmovmskb %xmm2, %eax
; AVX1-NEXT:    shll $16, %eax
; AVX1-NEXT:    orl %edx, %eax
; AVX1-NEXT:    shlq $32, %rax
; AVX1-NEXT:    orq %rcx, %rax
; AVX1-NEXT:    vzeroupper
; AVX1-NEXT:    retq
;
; AVX2-LABEL: v64i8:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vpcmpgtb %ymm3, %ymm1, %ymm1
; AVX2-NEXT:    vpcmpgtb %ymm2, %ymm0, %ymm0
; AVX2-NEXT:    vpcmpgtb %ymm7, %ymm5, %ymm2
; AVX2-NEXT:    vpand %ymm2, %ymm1, %ymm1
; AVX2-NEXT:    vpcmpgtb %ymm6, %ymm4, %ymm2
; AVX2-NEXT:    vpand %ymm2, %ymm0, %ymm0
; AVX2-NEXT:    vpmovmskb %ymm0, %ecx
; AVX2-NEXT:    vpmovmskb %ymm1, %eax
; AVX2-NEXT:    shlq $32, %rax
; AVX2-NEXT:    orq %rcx, %rax
; AVX2-NEXT:    vzeroupper
; AVX2-NEXT:    retq
;
; AVX512F-LABEL: v64i8:
; AVX512F:       # %bb.0:
; AVX512F-NEXT:    vpcmpgtb %ymm3, %ymm1, %ymm1
; AVX512F-NEXT:    vextracti128 $1, %ymm1, %xmm3
; AVX512F-NEXT:    vpmovsxbd %xmm3, %zmm3
; AVX512F-NEXT:    vptestmd %zmm3, %zmm3, %k1
; AVX512F-NEXT:    vpmovsxbd %xmm1, %zmm1
; AVX512F-NEXT:    vptestmd %zmm1, %zmm1, %k2
; AVX512F-NEXT:    vpcmpgtb %ymm2, %ymm0, %ymm0
; AVX512F-NEXT:    vextracti128 $1, %ymm0, %xmm1
; AVX512F-NEXT:    vpmovsxbd %xmm1, %zmm1
; AVX512F-NEXT:    vptestmd %zmm1, %zmm1, %k3
; AVX512F-NEXT:    vpmovsxbd %xmm0, %zmm0
; AVX512F-NEXT:    vptestmd %zmm0, %zmm0, %k4
; AVX512F-NEXT:    vpcmpgtb %ymm7, %ymm5, %ymm0
; AVX512F-NEXT:    vextracti128 $1, %ymm0, %xmm1
; AVX512F-NEXT:    vpmovsxbd %xmm1, %zmm1
; AVX512F-NEXT:    vpmovsxbd %xmm0, %zmm0
; AVX512F-NEXT:    vpcmpgtb %ymm6, %ymm4, %ymm2
; AVX512F-NEXT:    vextracti128 $1, %ymm2, %xmm3
; AVX512F-NEXT:    vpmovsxbd %xmm3, %zmm3
; AVX512F-NEXT:    vpmovsxbd %xmm2, %zmm2
; AVX512F-NEXT:    vptestmd %zmm2, %zmm2, %k0 {%k4}
; AVX512F-NEXT:    kmovw %k0, %eax
; AVX512F-NEXT:    vptestmd %zmm3, %zmm3, %k0 {%k3}
; AVX512F-NEXT:    kmovw %k0, %ecx
; AVX512F-NEXT:    shll $16, %ecx
; AVX512F-NEXT:    orl %eax, %ecx
; AVX512F-NEXT:    vptestmd %zmm0, %zmm0, %k0 {%k2}
; AVX512F-NEXT:    kmovw %k0, %edx
; AVX512F-NEXT:    vptestmd %zmm1, %zmm1, %k0 {%k1}
; AVX512F-NEXT:    kmovw %k0, %eax
; AVX512F-NEXT:    shll $16, %eax
; AVX512F-NEXT:    orl %edx, %eax
; AVX512F-NEXT:    shlq $32, %rax
; AVX512F-NEXT:    orq %rcx, %rax
; AVX512F-NEXT:    vzeroupper
; AVX512F-NEXT:    retq
;
; AVX512BW-LABEL: v64i8:
; AVX512BW:       # %bb.0:
; AVX512BW-NEXT:    vpcmpgtb %zmm1, %zmm0, %k1
; AVX512BW-NEXT:    vpcmpgtb %zmm3, %zmm2, %k0 {%k1}
; AVX512BW-NEXT:    kmovq %k0, %rax
; AVX512BW-NEXT:    vzeroupper
; AVX512BW-NEXT:    retq
  %x0 = icmp sgt <64 x i8> %a, %b
  %x1 = icmp sgt <64 x i8> %c, %d
  %y = and <64 x i1> %x0, %x1
  %res = bitcast <64 x i1> %y to i64
  ret i64 %res
}
