// Copyright distributed.net 1997 - All Rights Reserved
// For use in distributed.net projects only.
// Any other distribution or use of this source violates copyright.
//
// $Log: csc-common-mmx.cpp,v $
// Revision 1.1  1999/12/08 05:35:46  remi
// Files moved from /csc to /csc/x86/mmx
//
// Revision 1.1.2.3  1999/12/06 11:21:06  remi
// Moved csc_transP2() from csc-common-mmx.h to csc-common-mmx.cpp.
//
// Revision 1.1.2.2  1999/11/23 23:39:45  remi
// csc_transP() optimized.
// modified csc_transP() calling convention.
//
// Revision 1.1.2.1  1999/11/22 18:58:11  remi
// Initial commit of MMX'fied CSC cores.
//
// Revision 1.1.2.3  1999/11/01 17:23:23  cyp
// renamed transX(...) to csc_transX(...) to avoid potential (future) symbol
// collisions.
//
// Revision 1.1.2.2  1999/10/24 23:54:54  remi
// Use Problem::core_membuffer instead of stack for CSC cores.
// Align frequently used memory to 16-byte boundary in CSC cores.
//
// Revision 1.1.2.1  1999/10/07 18:41:14  cyp
// sync'd from head
//
// Revision 1.1  1999/07/23 02:43:06  fordbr
// CSC cores added
//
//

#define __IN_CSC_COMMON_CPP

#include "csc-common-mmx.h"

const ulong mmNOT
#if defined(__GNUC__)
//__attribute ((aligned (32)))
#endif
  = _1;

// ------------------------------------------------------------------
// bitslice version of c0..c8
const ulong csc_tabc_mmx[9][64]
#if defined(__GNUC__)
//__attribute ((aligned (32)))
#endif
 = {
  { // c0 == 0x290d61409ceb9e8f
    _1, _1, _1, _1, _0, _0, _0, _1, _0, _1, _1, _1, _1, _0, _0, _1, 
    _1, _1, _0, _1, _0, _1, _1, _1, _0, _0, _1, _1, _1, _0, _0, _1, 
    _0, _0, _0, _0, _0, _0, _1, _0, _1, _0, _0, _0, _0, _1, _1, _0, 
    _1, _0, _1, _1, _0, _0, _0, _0, _1, _0, _0, _1, _0, _1, _0, _0  },
  { // c1 == 0x1f855f585b013986
    _0, _1, _1, _0, _0, _0, _0, _1, _1, _0, _0, _1, _1, _1, _0, _0, 
    _1, _0, _0, _0, _0, _0, _0, _0, _1, _1, _0, _1, _1, _0, _1, _0, 
    _0, _0, _0, _1, _1, _0, _1, _0, _1, _1, _1, _1, _1, _0, _1, _0, 
    _1, _0, _1, _0, _0, _0, _0, _1, _1, _1, _1, _1, _1, _0, _0, _0  },
  { // c2 == 0x972ed7d635ae1716
    _0, _1, _1, _0, _1, _0, _0, _0, _1, _1, _1, _0, _1, _0, _0, _0, 
    _0, _1, _1, _1, _0, _1, _0, _1, _1, _0, _1, _0, _1, _1, _0, _0, 
    _0, _1, _1, _0, _1, _0, _1, _1, _1, _1, _1, _0, _1, _0, _1, _1, 
    _0, _1, _1, _1, _0, _1, _0, _0, _1, _1, _1, _0, _1, _0, _0, _1  },
  { // c3 == 0x21b6694ea5728708
    _0, _0, _0, _1, _0, _0, _0, _0, _1, _1, _1, _0, _0, _0, _0, _1, 
    _0, _1, _0, _0, _1, _1, _1, _0, _1, _0, _1, _0, _0, _1, _0, _1, 
    _0, _1, _1, _1, _0, _0, _1, _0, _1, _0, _0, _1, _0, _1, _1, _0, 
    _0, _1, _1, _0, _1, _1, _0, _1, _1, _0, _0, _0, _0, _1, _0, _0  },
  { // c4 == 0x3c18e6e7faadb889
    _1, _0, _0, _1, _0, _0, _0, _1, _0, _0, _0, _1, _1, _1, _0, _1, 
    _1, _0, _1, _1, _0, _1, _0, _1, _0, _1, _0, _1, _1, _1, _1, _1, 
    _1, _1, _1, _0, _0, _1, _1, _1, _0, _1, _1, _0, _0, _1, _1, _1, 
    _0, _0, _0, _1, _1, _0, _0, _0, _0, _0, _1, _1, _1, _1, _0, _0  },
  { // c5 == 0xb700f76f73841163
    _1, _1, _0, _0, _0, _1, _1, _0, _1, _0, _0, _0, _1, _0, _0, _0, 
    _0, _0, _1, _0, _0, _0, _0, _1, _1, _1, _0, _0, _1, _1, _1, _0, 
    _1, _1, _1, _1, _0, _1, _1, _0, _1, _1, _1, _0, _1, _1, _1, _1, 
    _0, _0, _0, _0, _0, _0, _0, _0, _1, _1, _1, _0, _1, _1, _0, _1  },
  { // c6 == 0x3f967f6ebf149dac
    _0, _0, _1, _1, _0, _1, _0, _1, _1, _0, _1, _1, _1, _0, _0, _1, 
    _0, _0, _1, _0, _1, _0, _0, _0, _1, _1, _1, _1, _1, _1, _0, _1, 
    _0, _1, _1, _1, _0, _1, _1, _0, _1, _1, _1, _1, _1, _1, _1, _0, 
    _0, _1, _1, _0, _1, _0, _0, _1, _1, _1, _1, _1, _1, _1, _0, _0  },
  { // c7 == 0xa40e7ef6204a6230
    _0, _0, _0, _0, _1, _1, _0, _0, _0, _1, _0, _0, _0, _1, _1, _0, 
    _0, _1, _0, _1, _0, _0, _1, _0, _0, _0, _0, _0, _0, _1, _0, _0, 
    _0, _1, _1, _0, _1, _1, _1, _1, _0, _1, _1, _1, _1, _1, _1, _0, 
    _0, _1, _1, _1, _0, _0, _0, _0, _0, _0, _1, _0, _0, _1, _0, _1  },
  { // c8 == 0x03c54b5a46a34465
    _1, _0, _1, _0, _0, _1, _1, _0, _0, _0, _1, _0, _0, _0, _1, _0, 
    _1, _1, _0, _0, _0, _1, _0, _1, _0, _1, _1, _0, _0, _0, _1, _0, 
    _0, _1, _0, _1, _1, _0, _1, _0, _1, _1, _0, _1, _0, _0, _1, _0, 
    _1, _0, _1, _0, _0, _0, _1, _1, _1, _1, _0, _0, _0, _0, _0, _0  } 
};

// bitslice version of e and e'
const ulong csc_tabe_mmx[2][64]
#if defined(__GNUC__)
//__attribute ((aligned (32)))
#endif
 = {
  { // e == 0xb7e151628aed2a6a
    _0, _1, _0, _1, _0, _1, _1, _0, _0, _1, _0, _1, _0, _1, _0, _0, 
    _1, _0, _1, _1, _0, _1, _1, _1, _0, _1, _0, _1, _0, _0, _0, _1, 
    _0, _1, _0, _0, _0, _1, _1, _0, _1, _0, _0, _0, _1, _0, _1, _0, 
    _1, _0, _0, _0, _0, _1, _1, _1, _1, _1, _1, _0, _1, _1, _0, _1  },
  { // e' == 0xbf7158809cf4f3c7
    _1, _1, _1, _0, _0, _0, _1, _1, _1, _1, _0, _0, _1, _1, _1, _1, 
    _0, _0, _1, _0, _1, _1, _1, _1, _0, _0, _1, _1, _1, _0, _0, _1, 
    _0, _0, _0, _0, _0, _0, _0, _1, _0, _0, _0, _1, _1, _0, _1, _0, 
    _1, _0, _0, _0, _1, _1, _1, _0, _1, _1, _1, _1, _1, _1, _0, _1  },
};


// parameters are passed in %mm0..%mm7 and in %edx
void csc_transP2( void )
{

#define _in0  "    0(%%edx)"
#define _in1  "    8(%%edx)"
#define _in2  "   16(%%edx)"
#define _in3  "   24(%%edx)"
#define _in4  "   32(%%edx)"
#define _in5  "   40(%%edx)"
#define _in6  "   48(%%edx)"
#define _in7  "   56(%%edx)"
#define _out0 " 0+64(%%edx)"
#define _out1 " 4+64(%%edx)"
#define _out2 " 8+64(%%edx)"
#define _out3 "12+64(%%edx)"
#define _out4 "16+64(%%edx)"
#define _out5 "20+64(%%edx)"
#define _out6 "24+64(%%edx)"
#define _out7 "28+64(%%edx)"
#define _mmNOT "%0"

// mmNOT      = 4
// in 5,6,7   = 4
// in 0,1,2,3 = 5
// in 4       = 8

// global allocation : in4 == %%mm4
  //		       in0 == %%mm0
  //                   in1 == %%mm1
  //                   in2 == %%mm2

  // Can someone tell me why, if I delete the line 'movq %%mm0, "_in0"'
  // and replace 'pxor "_in0",%%mm6' by 'pxor %%mm0,%%mm6' later in the
  // code, there's a ~3.6% drop in performance on core #0/#1 ?? 
  // (1012 -> 986)
  // How a memory access can be faster than a register access ??
  //
  // offsets in the final executable WITH movq %%mm0, "_in0" :
  // 0806c2a0 T csc_transP
  // 0806c3e0 T csc_transP2
  // 0806c520 T cscipher_bitslicer_6b
  // 08070460 T csc_unit_func_6b
  //
  // offsets in the final executable WITHOUT movq %%mm0, "_in0" :
  // 0806c2a0 T csc_transP
  // 0806c3e0 T csc_transP2
  // 0806c500 T cscipher_bitslicer_6b  <-- ??
  // 08070440 T csc_unit_func_6b


  asm volatile ("

  ## //csc_transF( in3, in2, in1, in0,	// in
  ## //            in7, in6, in5, in4 );// xor-out
  ## {
  ## ulong t04 = ~in3;		    ulong t06 =  in2 | in3;
  ## in4      ^=  t04 | in0;	    ulong t07 =  t06 ^ t04;
  ## ulong t09 =  (t07 ^ in1) | in2;   in7      ^=  t07;
  ## in6      ^=  t09;                 in5      ^=  (t09 ^ in0) | in1;
  ## }
	movq	%%mm0, "_in0"

	movq	%%mm7, "_in7"
	movq	%%mm3, %%mm7	# mm7 = in3
	movq	%%mm3, "_in3"
	pxor	"_mmNOT", %%mm3	# mm3 = t04 = ~in3
	movq	%%mm6, "_in6"
	movq	%%mm3, %%mm6	# mm6 = t04
	por	%%mm2, %%mm7	# mm7 = t06 = in2 | in3
	por	%%mm0, %%mm3	# mm3 = t04 | in0
	movq	%%mm5, "_in5"
	pxor	%%mm6, %%mm7	# mm7 = t07 = t06 ^ to4
	pxor	%%mm3, %%mm4	# mm4 = in4 ^= t04 | in0
	movq	%%mm7, %%mm5	# mm5 = t07
	pxor	%%mm1, %%mm5	# mm5 = t07 ^ in1
	pxor	"_in7", %%mm7	# mm7 = in7 ^= t07
	por	%%mm2, %%mm5	# mm5 = t09 = (t07 ^ in1) | in2
	movq	%%mm5, %%mm6	# mm6 = t09
	pxor	"_in0", %%mm6	# mm6 = t09 ^ in0
	#pxor	%%mm0, %%mm6
	pxor	"_in6", %%mm5	# mm5 = in6 ^= t09
	por	%%mm1, %%mm6	# mm6 = (t09 ^ in0) | in1
	pxor	"_in5", %%mm6	# mm6 = in5 ^= (t09 ^ in0) | in1
	
  ## // csc_transG( in7, in6, in5, in4,  // in
  ## //             in3, in2, in1, in0 );// xor-out
  ## {
  ## ulong t06 = (in4 & in5) ^ (in4 | in7);   ulong t08 = (in4 | in6) ^ in7;
  ## out2 = (in2 ^= t06);                     ulong t10 = (t08 | t06) ^ in4;
  ## ulong t13 = (in4 & in6) ^ (in4 | in5);   out0 = (in0 ^= t10);
  ## out3 = (in3 ^= ~t13);                    out1 = (in1 ^= ~(t10 ^ t08) ^ (t13 | t06));
  ## }

	movq	%%mm6, "_in5"	# -- mm6 free
	pand	%%mm4, %%mm6	# mm6 = in4 & in5
	movq	%%mm7, "_in7"	# -- mm7 free
	movq	%%mm7, %%mm3	# mm3 = in7
	por	%%mm4, %%mm7	# mm7 = in4 | in7
	movq	%%mm5, "_in6"	# mm5 free
	pxor	%%mm6, %%mm7	# + mm7 = t06 = (in4 & in5) ^ (in4 | in7)
				# -- mm6 free
	por	%%mm4, %%mm5	# mm5 = in4 | in6
	pxor	%%mm7, %%mm2	#### mm2 = out2 = in2 ^= t06
	pxor	%%mm3, %%mm5	# + mm5 = t08 = (in4 | in6) ^ in7;
	movq	%%mm7, %%mm3	# mm3 = t06
	movl	"_out2",%%eax
	movq	%%mm2, (%%eax)	# out2 = in2
	movq	"_in6",%%mm6	# mm6 = in6
	por	%%mm5, %%mm7	# mm7 = t08 | t06
	pand	%%mm4, %%mm6	# mm6 = in4 & in6
	pxor	%%mm4, %%mm7	# + mm7 = t10 = (t08 | t06) ^ in4
	pxor	%%mm7, %%mm5	# mm5 = t10 ^ t08
	pxor	%%mm7, %%mm0	#### mm0 = in0 ^= t10
				# -- mm7 free
	movq	"_in5",%%mm7	# mm7 = in5
	pxor	"_mmNOT",%%mm5	# mm5 = ~(t10 ^ t08)
	por	%%mm4, %%mm7	# mm7 = in4 | in5
	movl	"_out0",%%eax
	movq	%%mm0, (%%eax)	# out0 = in0
	pxor	%%mm6, %%mm7	# + mm7 = t13 = (in4 & in6) ^ (in4 | in5)
				# -- mm6 free
	movq	%%mm7, %%mm6	# mm6 = t13
	por	%%mm3, %%mm7	# mm7 = t13 | t06
				# -- mm3 free
	pxor	"_mmNOT",%%mm6	# mm6 = ~t13
	pxor	%%mm7, %%mm5	# mm5 = ~(t10 ^ t08) ^ (t13 | t06)
				# -- mm7 free
	pxor	"_in3",%%mm6	#### mm6 = out3 = in3 ^ ~t13
	pxor	%%mm5, %%mm1	#### mm1 = out1 = (in1 ^= ~(t10 ^ t08) ^ (t13 | t06))
				# -- mm5 free

  ## // csc_transF( in3, in2, in1, in0,	 // in
  ## //             in7, in6, in5, in4 );// xor-out
  ## {
  ## ulong t04 = ~in3;           ulong t06 = in2 | in3;
  ## out4 = in4 ^ (t04 | in0);   ulong t07 = t06 ^ t04;
  ## ulong t08 = t07 ^ in1;      out7 = in7 ^ t07;	   
  ## ulong t09 = t08 | in2;
  ## out6 = in6 ^ t09;           out5 = in5 ^ ((t09 ^ in0) | in1);
  ## }

	movl	"_out3",%%eax
	movq	%%mm6, %%mm3	# mm3 = in3
	movq	%%mm6, (%%eax)
	pxor	"_mmNOT", %%mm6	# mm6 = t04 = ~in3
	por	%%mm2, %%mm3	# mm3 = t06 = in2 | in3
	movl	"_out1",%%eax
	movq	%%mm6, %%mm7	# mm7 = t04
	movq	%%mm1, (%%eax)
	por	%%mm0, %%mm6	# mm6 = t04 | in0
	pxor	%%mm7, %%mm3	# mm3 = t07 = t06 ^ t04
				# -- mm7 free
	movq	"_in7", %%mm7	# mm7 = in7
	pxor	%%mm4, %%mm6	### mm6 = out4 = in4 ^ (t04 | in0)
				# -- mm4 free
	movl	"_out4",%%eax
	movq	%%mm3, %%mm4	# mm4 = t07
	movq	"_in6", %%mm5	# mm5 = in6
	pxor	%%mm1, %%mm3	# mm3 = t08 = t07 ^ in1
	movq	%%mm6, (%%eax)	# -- mm6 free
	pxor	%%mm4, %%mm7	### mm7 = out7 = in7 ^ t07
				# -- mm4 free
	por	%%mm2, %%mm3	# mm3 = t09 = t08 | in2
				# -- mm2 free
	movl	"_out7",%%eax
	movq	%%mm7, (%%eax)	# -- mm7 free
	movq	%%mm3, %%mm4	# mm4 = t09
	movq	"_in5", %%mm2	# mm2 = in5
	pxor	%%mm0, %%mm4	# mm4 = t09 ^ in0
	pxor	%%mm5, %%mm3	### mm3 = out6 = in6 ^ t09
	por	%%mm1, %%mm4	# mm4 = (t09 ^ in0) | in1
	movl	"_out6",%%eax
	movq	%%mm3, (%%eax)	# -- mm3 free
	pxor	%%mm2, %%mm4	### mm4 = out5 = in5 ^ ((t09 ^ in0) | in1)
	movl	"_out5",%%eax
	movq	%%mm4, (%%eax)

  ": 
   : "m"(mmNOT)
   : "%eax", "%edx"

  );
#undef _in0
#undef _in1
#undef _in2
#undef _in3
#undef _in4
#undef _in5
#undef _in6
#undef _in7
#undef _out0
#undef _out1
#undef _out2
#undef _out3
#undef _out4
#undef _out5
#undef _out6
#undef _out7
#undef _mmNOT

}