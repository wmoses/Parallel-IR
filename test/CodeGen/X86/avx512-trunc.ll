; RUN: llc < %s -mtriple=x86_64-apple-darwin -mattr=+avx512f | FileCheck %s --check-prefix=ALL --check-prefix=KNL
; RUN: llc < %s -mtriple=x86_64-apple-darwin -mattr=+avx512f -mattr=+avx512vl -mattr=+avx512bw -mattr=+avx512dq | FileCheck %s --check-prefix=ALL --check-prefix=SKX

 attributes #0 = { nounwind }

define <16 x i8> @trunc_16x32_to_16x8(<16 x i32> %i) #0 {
; ALL-LABEL: trunc_16x32_to_16x8:
; ALL:       ## BB#0:
; ALL-NEXT:    vpmovdb %zmm0, %xmm0
; ALL-NEXT:    retq
  %x = trunc <16 x i32> %i to <16 x i8>
  ret <16 x i8> %x
}

define <8 x i16> @trunc_8x64_to_8x16(<8 x i64> %i) #0 {
; ALL-LABEL: trunc_8x64_to_8x16:
; ALL:       ## BB#0:
; ALL-NEXT:    vpmovqw %zmm0, %xmm0
; ALL-NEXT:    retq
  %x = trunc <8 x i64> %i to <8 x i16>
  ret <8 x i16> %x
}

define <16 x i16> @trunc_v16i32_to_v16i16(<16 x i32> %x) #0 {
; ALL-LABEL: trunc_v16i32_to_v16i16:
; ALL:       ## BB#0:
; ALL-NEXT:    vpmovdw %zmm0, %ymm0
; ALL-NEXT:    retq
  %1 = trunc <16 x i32> %x to <16 x i16>
  ret <16 x i16> %1
}

define <8 x i8> @trunc_qb_512(<8 x i64> %i) #0 {
; ALL-LABEL: trunc_qb_512:
; ALL:       ## BB#0:
; ALL-NEXT:    vpmovqw %zmm0, %xmm0
; ALL-NEXT:    retq
  %x = trunc <8 x i64> %i to <8 x i8>
  ret <8 x i8> %x
}

define void @trunc_qb_512_mem(<8 x i64> %i, <8 x i8>* %res) #0 {
; ALL-LABEL: trunc_qb_512_mem:
; ALL:       ## BB#0:
; ALL-NEXT:    vpmovqb %zmm0, (%rdi)
; ALL-NEXT:    retq
    %x = trunc <8 x i64> %i to <8 x i8>
    store <8 x i8> %x, <8 x i8>* %res
    ret void
}

define <4 x i8> @trunc_qb_256(<4 x i64> %i) #0 {
; KNL-LABEL: trunc_qb_256:
; KNL:       ## BB#0:
; KNL-NEXT:    vpmovqd %zmm0, %ymm0
; KNL-NEXT:    retq
;
; SKX-LABEL: trunc_qb_256:
; SKX:       ## BB#0:
; SKX-NEXT:    vpmovqd %ymm0, %xmm0
; SKX-NEXT:    retq
  %x = trunc <4 x i64> %i to <4 x i8>
  ret <4 x i8> %x
}

define void @trunc_qb_256_mem(<4 x i64> %i, <4 x i8>* %res) #0 {
; KNL-LABEL: trunc_qb_256_mem:
; KNL:       ## BB#0:
; KNL-NEXT:    vpmovqd %zmm0, %ymm0
; KNL-NEXT:    vpshufb {{.*#+}} xmm0 = xmm0[0,4,8,12,u,u,u,u,u,u,u,u,u,u,u,u]
; KNL-NEXT:    vmovd %xmm0, (%rdi)
; KNL-NEXT:    retq
;
; SKX-LABEL: trunc_qb_256_mem:
; SKX:       ## BB#0:
; SKX-NEXT:    vpmovqb %ymm0, (%rdi)
; SKX-NEXT:    retq
    %x = trunc <4 x i64> %i to <4 x i8>
    store <4 x i8> %x, <4 x i8>* %res
    ret void
}

define <2 x i8> @trunc_qb_128(<2 x i64> %i) #0 {
; ALL-LABEL: trunc_qb_128:
; ALL:       ## BB#0:
; ALL-NEXT:    retq
  %x = trunc <2 x i64> %i to <2 x i8>
  ret <2 x i8> %x
}

define void @trunc_qb_128_mem(<2 x i64> %i, <2 x i8>* %res) #0 {
; KNL-LABEL: trunc_qb_128_mem:
; KNL:       ## BB#0:
; KNL-NEXT:    vpshufb {{.*#+}} xmm0 = xmm0[0,8,u,u,u,u,u,u,u,u,u,u,u,u,u,u]
; KNL-NEXT:    vmovd %xmm0, %eax
; KNL-NEXT:    movw %ax, (%rdi)
; KNL-NEXT:    retq
;
; SKX-LABEL: trunc_qb_128_mem:
; SKX:       ## BB#0:
; SKX-NEXT:    vpmovqb %xmm0, (%rdi)
; SKX-NEXT:    retq
    %x = trunc <2 x i64> %i to <2 x i8>
    store <2 x i8> %x, <2 x i8>* %res
    ret void
}

define <8 x i16> @trunc_qw_512(<8 x i64> %i) #0 {
; ALL-LABEL: trunc_qw_512:
; ALL:       ## BB#0:
; ALL-NEXT:    vpmovqw %zmm0, %xmm0
; ALL-NEXT:    retq
  %x = trunc <8 x i64> %i to <8 x i16>
  ret <8 x i16> %x
}

define void @trunc_qw_512_mem(<8 x i64> %i, <8 x i16>* %res) #0 {
; ALL-LABEL: trunc_qw_512_mem:
; ALL:       ## BB#0:
; ALL-NEXT:    vpmovqw %zmm0, (%rdi)
; ALL-NEXT:    retq
    %x = trunc <8 x i64> %i to <8 x i16>
    store <8 x i16> %x, <8 x i16>* %res
    ret void
}

define <4 x i16> @trunc_qw_256(<4 x i64> %i) #0 {
; KNL-LABEL: trunc_qw_256:
; KNL:       ## BB#0:
; KNL-NEXT:    vpmovqd %zmm0, %ymm0
; KNL-NEXT:    retq
;
; SKX-LABEL: trunc_qw_256:
; SKX:       ## BB#0:
; SKX-NEXT:    vpmovqd %ymm0, %xmm0
; SKX-NEXT:    retq
  %x = trunc <4 x i64> %i to <4 x i16>
  ret <4 x i16> %x
}

define void @trunc_qw_256_mem(<4 x i64> %i, <4 x i16>* %res) #0 {
; KNL-LABEL: trunc_qw_256_mem:
; KNL:       ## BB#0:
; KNL-NEXT:    vpmovqd %zmm0, %ymm0
; KNL-NEXT:    vpshufb {{.*#+}} xmm0 = xmm0[0,1,4,5,8,9,12,13,8,9,12,13,12,13,14,15]
; KNL-NEXT:    vmovq %xmm0, (%rdi)
; KNL-NEXT:    retq
;
; SKX-LABEL: trunc_qw_256_mem:
; SKX:       ## BB#0:
; SKX-NEXT:    vpmovqw %ymm0, (%rdi)
; SKX-NEXT:    retq
    %x = trunc <4 x i64> %i to <4 x i16>
    store <4 x i16> %x, <4 x i16>* %res
    ret void
}

define <2 x i16> @trunc_qw_128(<2 x i64> %i) #0 {
; ALL-LABEL: trunc_qw_128:
; ALL:       ## BB#0:
; ALL-NEXT:    retq
  %x = trunc <2 x i64> %i to <2 x i16>
  ret <2 x i16> %x
}

define void @trunc_qw_128_mem(<2 x i64> %i, <2 x i16>* %res) #0 {
; KNL-LABEL: trunc_qw_128_mem:
; KNL:       ## BB#0:
; KNL-NEXT:    vpshufd {{.*#+}} xmm0 = xmm0[0,2,2,3]
; KNL-NEXT:    vpshuflw {{.*#+}} xmm0 = xmm0[0,2,2,3,4,5,6,7]
; KNL-NEXT:    vmovd %xmm0, (%rdi)
; KNL-NEXT:    retq
;
; SKX-LABEL: trunc_qw_128_mem:
; SKX:       ## BB#0:
; SKX-NEXT:    vpmovqw %xmm0, (%rdi)
; SKX-NEXT:    retq
    %x = trunc <2 x i64> %i to <2 x i16>
    store <2 x i16> %x, <2 x i16>* %res
    ret void
}

define <8 x i32> @trunc_qd_512(<8 x i64> %i) #0 {
; ALL-LABEL: trunc_qd_512:
; ALL:       ## BB#0:
; ALL-NEXT:    vpmovqd %zmm0, %ymm0
; ALL-NEXT:    retq
  %x = trunc <8 x i64> %i to <8 x i32>
  ret <8 x i32> %x
}

define void @trunc_qd_512_mem(<8 x i64> %i, <8 x i32>* %res) #0 {
; ALL-LABEL: trunc_qd_512_mem:
; ALL:       ## BB#0:
; ALL-NEXT:    vpmovqd %zmm0, (%rdi)
; ALL-NEXT:    retq
    %x = trunc <8 x i64> %i to <8 x i32>
    store <8 x i32> %x, <8 x i32>* %res
    ret void
}

define <4 x i32> @trunc_qd_256(<4 x i64> %i) #0 {
; KNL-LABEL: trunc_qd_256:
; KNL:       ## BB#0:
; KNL-NEXT:    vpmovqd %zmm0, %ymm0
; KNL-NEXT:    retq
;
; SKX-LABEL: trunc_qd_256:
; SKX:       ## BB#0:
; SKX-NEXT:    vpmovqd %ymm0, %xmm0
; SKX-NEXT:    retq
  %x = trunc <4 x i64> %i to <4 x i32>
  ret <4 x i32> %x
}

define void @trunc_qd_256_mem(<4 x i64> %i, <4 x i32>* %res) #0 {
; KNL-LABEL: trunc_qd_256_mem:
; KNL:       ## BB#0:
; KNL-NEXT:    vpmovqd %zmm0, %ymm0
; KNL-NEXT:    vmovaps %xmm0, (%rdi)
; KNL-NEXT:    retq
;
; SKX-LABEL: trunc_qd_256_mem:
; SKX:       ## BB#0:
; SKX-NEXT:    vpmovqd %ymm0, (%rdi)
; SKX-NEXT:    retq
    %x = trunc <4 x i64> %i to <4 x i32>
    store <4 x i32> %x, <4 x i32>* %res
    ret void
}

define <2 x i32> @trunc_qd_128(<2 x i64> %i) #0 {
; ALL-LABEL: trunc_qd_128:
; ALL:       ## BB#0:
; ALL-NEXT:    retq
  %x = trunc <2 x i64> %i to <2 x i32>
  ret <2 x i32> %x
}

define void @trunc_qd_128_mem(<2 x i64> %i, <2 x i32>* %res) #0 {
; KNL-LABEL: trunc_qd_128_mem:
; KNL:       ## BB#0:
; KNL-NEXT:    vpshufd {{.*#+}} xmm0 = xmm0[0,2,2,3]
; KNL-NEXT:    vmovq %xmm0, (%rdi)
; KNL-NEXT:    retq
;
; SKX-LABEL: trunc_qd_128_mem:
; SKX:       ## BB#0:
; SKX-NEXT:    vpmovqd %xmm0, (%rdi)
; SKX-NEXT:    retq
    %x = trunc <2 x i64> %i to <2 x i32>
    store <2 x i32> %x, <2 x i32>* %res
    ret void
}

define <16 x i8> @trunc_db_512(<16 x i32> %i) #0 {
; ALL-LABEL: trunc_db_512:
; ALL:       ## BB#0:
; ALL-NEXT:    vpmovdb %zmm0, %xmm0
; ALL-NEXT:    retq
  %x = trunc <16 x i32> %i to <16 x i8>
  ret <16 x i8> %x
}

define void @trunc_db_512_mem(<16 x i32> %i, <16 x i8>* %res) #0 {
; ALL-LABEL: trunc_db_512_mem:
; ALL:       ## BB#0:
; ALL-NEXT:    vpmovdb %zmm0, (%rdi)
; ALL-NEXT:    retq
    %x = trunc <16 x i32> %i to <16 x i8>
    store <16 x i8> %x, <16 x i8>* %res
    ret void
}

define <8 x i8> @trunc_db_256(<8 x i32> %i) #0 {
; KNL-LABEL: trunc_db_256:
; KNL:       ## BB#0:
; KNL-NEXT:    vpmovdw %zmm0, %ymm0
; KNL-NEXT:    retq
;
; SKX-LABEL: trunc_db_256:
; SKX:       ## BB#0:
; SKX-NEXT:    vpmovdw %ymm0, %xmm0
; SKX-NEXT:    retq
  %x = trunc <8 x i32> %i to <8 x i8>
  ret <8 x i8> %x
}

define void @trunc_db_256_mem(<8 x i32> %i, <8 x i8>* %res) #0 {
; KNL-LABEL: trunc_db_256_mem:
; KNL:       ## BB#0:
; KNL-NEXT:    vpmovdw %zmm0, %ymm0
; KNL-NEXT:    vpshufb {{.*#+}} xmm0 = xmm0[0,2,4,6,8,10,12,14,u,u,u,u,u,u,u,u]
; KNL-NEXT:    vmovq %xmm0, (%rdi)
; KNL-NEXT:    retq
;
; SKX-LABEL: trunc_db_256_mem:
; SKX:       ## BB#0:
; SKX-NEXT:    vpmovdb %ymm0, (%rdi)
; SKX-NEXT:    retq
    %x = trunc <8 x i32> %i to <8 x i8>
    store <8 x i8> %x, <8 x i8>* %res
    ret void
}

define <4 x i8> @trunc_db_128(<4 x i32> %i) #0 {
; ALL-LABEL: trunc_db_128:
; ALL:       ## BB#0:
; ALL-NEXT:    retq
  %x = trunc <4 x i32> %i to <4 x i8>
  ret <4 x i8> %x
}

define void @trunc_db_128_mem(<4 x i32> %i, <4 x i8>* %res) #0 {
; KNL-LABEL: trunc_db_128_mem:
; KNL:       ## BB#0:
; KNL-NEXT:    vpshufb {{.*#+}} xmm0 = xmm0[0,4,8,12,u,u,u,u,u,u,u,u,u,u,u,u]
; KNL-NEXT:    vmovd %xmm0, (%rdi)
; KNL-NEXT:    retq
;
; SKX-LABEL: trunc_db_128_mem:
; SKX:       ## BB#0:
; SKX-NEXT:    vpmovdb %xmm0, (%rdi)
; SKX-NEXT:    retq
    %x = trunc <4 x i32> %i to <4 x i8>
    store <4 x i8> %x, <4 x i8>* %res
    ret void
}

define <16 x i16> @trunc_dw_512(<16 x i32> %i) #0 {
; ALL-LABEL: trunc_dw_512:
; ALL:       ## BB#0:
; ALL-NEXT:    vpmovdw %zmm0, %ymm0
; ALL-NEXT:    retq
  %x = trunc <16 x i32> %i to <16 x i16>
  ret <16 x i16> %x
}

define void @trunc_dw_512_mem(<16 x i32> %i, <16 x i16>* %res) #0 {
; ALL-LABEL: trunc_dw_512_mem:
; ALL:       ## BB#0:
; ALL-NEXT:    vpmovdw %zmm0, (%rdi)
; ALL-NEXT:    retq
    %x = trunc <16 x i32> %i to <16 x i16>
    store <16 x i16> %x, <16 x i16>* %res
    ret void
}

define <8 x i16> @trunc_dw_256(<8 x i32> %i) #0 {
; KNL-LABEL: trunc_dw_256:
; KNL:       ## BB#0:
; KNL-NEXT:    vpmovdw %zmm0, %ymm0
; KNL-NEXT:    retq
;
; SKX-LABEL: trunc_dw_256:
; SKX:       ## BB#0:
; SKX-NEXT:    vpmovdw %ymm0, %xmm0
; SKX-NEXT:    retq
  %x = trunc <8 x i32> %i to <8 x i16>
  ret <8 x i16> %x
}

define void @trunc_dw_256_mem(<8 x i32> %i, <8 x i16>* %res) #0 {
; KNL-LABEL: trunc_dw_256_mem:
; KNL:       ## BB#0:
; KNL-NEXT:    vpmovdw %zmm0, %ymm0
; KNL-NEXT:    vmovaps %xmm0, (%rdi)
; KNL-NEXT:    retq
;
; SKX-LABEL: trunc_dw_256_mem:
; SKX:       ## BB#0:
; SKX-NEXT:    vpmovdw %ymm0, (%rdi)
; SKX-NEXT:    retq
    %x = trunc <8 x i32> %i to <8 x i16>
    store <8 x i16> %x, <8 x i16>* %res
    ret void
}

define void @trunc_dw_128_mem(<4 x i32> %i, <4 x i16>* %res) #0 {
; KNL-LABEL: trunc_dw_128_mem:
; KNL:       ## BB#0:
; KNL-NEXT:    vpshufb {{.*#+}} xmm0 = xmm0[0,1,4,5,8,9,12,13,8,9,12,13,12,13,14,15]
; KNL-NEXT:    vmovq %xmm0, (%rdi)
; KNL-NEXT:    retq
;
; SKX-LABEL: trunc_dw_128_mem:
; SKX:       ## BB#0:
; SKX-NEXT:    vpmovdw %xmm0, (%rdi)
; SKX-NEXT:    retq
    %x = trunc <4 x i32> %i to <4 x i16>
    store <4 x i16> %x, <4 x i16>* %res
    ret void
}

define <32 x i8> @trunc_wb_512(<32 x i16> %i) #0 {
; KNL-LABEL: trunc_wb_512:
; KNL:       ## BB#0:
; KNL-NEXT:    vpmovsxwd %ymm0, %zmm0
; KNL-NEXT:    vpmovdb %zmm0, %xmm0
; KNL-NEXT:    vpmovsxwd %ymm1, %zmm1
; KNL-NEXT:    vpmovdb %zmm1, %xmm1
; KNL-NEXT:    vinsertf128 $1, %xmm1, %ymm0, %ymm0
; KNL-NEXT:    retq
;
; SKX-LABEL: trunc_wb_512:
; SKX:       ## BB#0:
; SKX-NEXT:    vpmovwb %zmm0, %ymm0
; SKX-NEXT:    retq
  %x = trunc <32 x i16> %i to <32 x i8>
  ret <32 x i8> %x
}

define void @trunc_wb_512_mem(<32 x i16> %i, <32 x i8>* %res) #0 {
; KNL-LABEL: trunc_wb_512_mem:
; KNL:       ## BB#0:
; KNL-NEXT:    vpmovsxwd %ymm0, %zmm0
; KNL-NEXT:    vpmovdb %zmm0, %xmm0
; KNL-NEXT:    vpmovsxwd %ymm1, %zmm1
; KNL-NEXT:    vpmovdb %zmm1, %xmm1
; KNL-NEXT:    vinsertf128 $1, %xmm1, %ymm0, %ymm0
; KNL-NEXT:    vmovaps %ymm0, (%rdi)
; KNL-NEXT:    retq
;
; SKX-LABEL: trunc_wb_512_mem:
; SKX:       ## BB#0:
; SKX-NEXT:    vpmovwb %zmm0, (%rdi)
; SKX-NEXT:    retq
    %x = trunc <32 x i16> %i to <32 x i8>
    store <32 x i8> %x, <32 x i8>* %res
    ret void
}

define <16 x i8> @trunc_wb_256(<16 x i16> %i) #0 {
; KNL-LABEL: trunc_wb_256:
; KNL:       ## BB#0:
; KNL-NEXT:    vpmovsxwd %ymm0, %zmm0
; KNL-NEXT:    vpmovdb %zmm0, %xmm0
; KNL-NEXT:    retq
;
; SKX-LABEL: trunc_wb_256:
; SKX:       ## BB#0:
; SKX-NEXT:    vpmovwb %ymm0, %xmm0
; SKX-NEXT:    retq
  %x = trunc <16 x i16> %i to <16 x i8>
  ret <16 x i8> %x
}

define void @trunc_wb_256_mem(<16 x i16> %i, <16 x i8>* %res) #0 {
; KNL-LABEL: trunc_wb_256_mem:
; KNL:       ## BB#0:
; KNL-NEXT:    vpmovsxwd %ymm0, %zmm0
; KNL-NEXT:    vpmovdb %zmm0, %xmm0
; KNL-NEXT:    vmovaps %xmm0, (%rdi)
; KNL-NEXT:    retq
;
; SKX-LABEL: trunc_wb_256_mem:
; SKX:       ## BB#0:
; SKX-NEXT:    vpmovwb %ymm0, (%rdi)
; SKX-NEXT:    retq
    %x = trunc <16 x i16> %i to <16 x i8>
    store <16 x i8> %x, <16 x i8>* %res
    ret void
}

define <8 x i8> @trunc_wb_128(<8 x i16> %i) #0 {
; ALL-LABEL: trunc_wb_128:
; ALL:       ## BB#0:
; ALL-NEXT:    retq
  %x = trunc <8 x i16> %i to <8 x i8>
  ret <8 x i8> %x
}

define void @trunc_wb_128_mem(<8 x i16> %i, <8 x i8>* %res) #0 {
; KNL-LABEL: trunc_wb_128_mem:
; KNL:       ## BB#0:
; KNL-NEXT:    vpshufb {{.*#+}} xmm0 = xmm0[0,2,4,6,8,10,12,14,u,u,u,u,u,u,u,u]
; KNL-NEXT:    vmovq %xmm0, (%rdi)
; KNL-NEXT:    retq
;
; SKX-LABEL: trunc_wb_128_mem:
; SKX:       ## BB#0:
; SKX-NEXT:    vpmovwb %xmm0, (%rdi)
; SKX-NEXT:    retq
    %x = trunc <8 x i16> %i to <8 x i8>
    store <8 x i8> %x, <8 x i8>* %res
    ret void
}
