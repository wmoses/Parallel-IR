; RUN: llvm-as < %s | llc -mtriple=i686-apple-darwin9 -mattr=sse41 | FileCheck %s -check-prefix=X32
; RUN: llvm-as < %s | llc -mtriple=x86_64-apple-darwin9 -mattr=sse41 | FileCheck %s -check-prefix=X64

@g16 = external global i16

define <4 x i32> @pinsrd_1(i32 %s, <4 x i32> %tmp) nounwind {
        %tmp1 = insertelement <4 x i32> %tmp, i32 %s, i32 1
        ret <4 x i32> %tmp1
; X32: pinsrd_1:
; X32:    pinsrd $1, 4(%esp), %xmm0

; X64: pinsrd_1:
; X64:    pinsrd $1, %edi, %xmm0
}

define <16 x i8> @pinsrb_1(i8 %s, <16 x i8> %tmp) nounwind {
        %tmp1 = insertelement <16 x i8> %tmp, i8 %s, i32 1
        ret <16 x i8> %tmp1
; X32: pinsrb_1:
; X32:    pinsrb $1, 4(%esp), %xmm0

; X64: pinsrb_1:
; X64:    pinsrb $1, %edi, %xmm0
}


define <2 x i64> @pmovsxbd_1(i32* %p) nounwind {
entry:
	%0 = load i32* %p, align 4
	%1 = insertelement <4 x i32> undef, i32 %0, i32 0
	%2 = insertelement <4 x i32> %1, i32 0, i32 1
	%3 = insertelement <4 x i32> %2, i32 0, i32 2
	%4 = insertelement <4 x i32> %3, i32 0, i32 3
	%5 = bitcast <4 x i32> %4 to <16 x i8>
	%6 = tail call <4 x i32> @llvm.x86.sse41.pmovsxbd(<16 x i8> %5) nounwind readnone
	%7 = bitcast <4 x i32> %6 to <2 x i64>
	ret <2 x i64> %7
        
; X32: _pmovsxbd_1:
; X32:   movl      4(%esp), %eax
; X32:   pmovsxbd   (%eax), %xmm0

; X64: _pmovsxbd_1:
; X64:   pmovsxbd   (%rdi), %xmm0
}

define <2 x i64> @pmovsxwd_1(i64* %p) nounwind readonly {
entry:
	%0 = load i64* %p		; <i64> [#uses=1]
	%tmp2 = insertelement <2 x i64> zeroinitializer, i64 %0, i32 0		; <<2 x i64>> [#uses=1]
	%1 = bitcast <2 x i64> %tmp2 to <8 x i16>		; <<8 x i16>> [#uses=1]
	%2 = tail call <4 x i32> @llvm.x86.sse41.pmovsxwd(<8 x i16> %1) nounwind readnone		; <<4 x i32>> [#uses=1]
	%3 = bitcast <4 x i32> %2 to <2 x i64>		; <<2 x i64>> [#uses=1]
	ret <2 x i64> %3
        
; X32: _pmovsxwd_1:
; X32:   movl 4(%esp), %eax
; X32:   pmovsxwd (%eax), %xmm0

; X64: _pmovsxwd_1:
; X64:   pmovsxwd (%rdi), %xmm0
}




define <2 x i64> @pmovzxbq_1() nounwind {
entry:
	%0 = load i16* @g16, align 2		; <i16> [#uses=1]
	%1 = insertelement <8 x i16> undef, i16 %0, i32 0		; <<8 x i16>> [#uses=1]
	%2 = bitcast <8 x i16> %1 to <16 x i8>		; <<16 x i8>> [#uses=1]
	%3 = tail call <2 x i64> @llvm.x86.sse41.pmovzxbq(<16 x i8> %2) nounwind readnone		; <<2 x i64>> [#uses=1]
	ret <2 x i64> %3

; X32: _pmovzxbq_1:
; X32:   movl	L_g16$non_lazy_ptr, %eax
; X32:   pmovzxbq	(%eax), %xmm0

; X64: _pmovzxbq_1:
; X64:   movq	_g16@GOTPCREL(%rip), %rax
; X64:   pmovzxbq	(%rax), %xmm0
}

declare <4 x i32> @llvm.x86.sse41.pmovsxbd(<16 x i8>) nounwind readnone
declare <4 x i32> @llvm.x86.sse41.pmovsxwd(<8 x i16>) nounwind readnone
declare <2 x i64> @llvm.x86.sse41.pmovzxbq(<16 x i8>) nounwind readnone
