// This is a conversion of r72-ks-scalarfusion to work with clang. It was generated
// manually with libav's gas-generator with the following command line
//
// GASPP_DEBUG=1 perl gas-preprocessor.pl -verbose -arch arm64 clang r72-ks-scalarfusion.S > r72-ks-scalarfusion-clang.S
//
// Clang as can't handle the code, but the Perl script is GPLv2, so just attaching
// including the pre-processed output is the cleanest solution. This file
// will have to be generated if r72-ks-scalarfusion.S is updated
//
// https://raw.githubusercontent.com/libav/gas-preprocessor/master/gas-preprocessor.pl
//
// scaleFusionEntry must also be renamed to _scalarFusionEntry

.text
.globl _scalarFusionEntry
_scalarFusionEntry:

  stp x29, x30, [sp, #-16]!


  stp x19, x20, [sp, #-16]!
  stp x21, x22, [sp, #-16]!
  stp x23, x24, [sp, #-16]!
  stp x25, x26, [sp, #-16]!
  stp x27, x28, [sp, #-16]!


  stp x0, x1, [sp, #-16]!


  ldr w0, constant_p
  ldr w1, constant_q
  mov w5, w0
  add w6, w0, w1

  mov w30, #2
  madd w7, w1, w30, w0

  mov w30, #3
  madd w8, w1, w30, w0

  mov w30, #4
  madd w9, w1, w30, w0

  mov w30, #5
  madd w10, w1, w30, w0

  mov w30, #6
  madd w11, w1, w30, w0

  mov w30, #7
  madd w12, w1, w30, w0

  mov w30, #8
  madd w13, w1, w30, w0

  mov w30, #9
  madd w14, w1, w30, w0

  mov w30, #10
  madd w15, w1, w30, w0

  mov w30, #11
  madd w16, w1, w30, w0

  mov w30, #12
  madd w17, w1, w30, w0

  mov w30, #13
  madd w18, w1, w30, w0

  mov w30, #14
  madd w19, w1, w30, w0

  mov w30, #15
  madd w20, w1, w30, w0

  mov w30, #16
  madd w21, w1, w30, w0

  mov w30, #17
  madd w22, w1, w30, w0

  mov w30, #18
  madd w23, w1, w30, w0

  mov w30, #19
  madd w24, w1, w30, w0

  mov w30, #20
  madd w25, w1, w30, w0

  mov w30, #21
  madd w26, w1, w30, w0

  mov w30, #22
  madd w27, w1, w30, w0

  mov w30, #23
  madd w28, w1, w30, w0

  mov w30, #24
  madd w29, w1, w30, w0

  mov w30, #25
  madd w30, w1, w30, w0

  ror w5, w5, #29

  add w2, w2, w5
  mov w1, #32
  sub w1, w1, w5
  ror w2, w2, w1

  add w6, w6, w5
 add w6, w6, w2
 ror w6, w6, #29
 add w3, w3, w6
 add w3, w3, w2
 add w1, w6, w2
 mov w0, #32
 sub w1, w0, w1
 ror w3, w3, w1



  add w7, w7, w6
 add w7, w7, w3
 ror w7, w7, #29
 add w4, w4, w7
 add w4, w4, w3
 add w1, w7, w3
 mov w0, #32
 sub w1, w0, w1
 ror w4, w4, w1



  add w8, w8, w7
 add w8, w8, w4
 ror w8, w8, #29
 add w2, w2, w8
 add w2, w2, w4
 add w1, w8, w4
 mov w0, #32
 sub w1, w0, w1
 ror w2, w2, w1



  add w9, w9, w8
 add w9, w9, w2
 ror w9, w9, #29
 add w3, w3, w9
 add w3, w3, w2
 add w1, w9, w2
 mov w0, #32
 sub w1, w0, w1
 ror w3, w3, w1


  add w10, w10, w9
 add w10, w10, w3
 ror w10, w10, #29
 add w4, w4, w10
 add w4, w4, w3
 add w1, w10, w3
 mov w0, #32
 sub w1, w0, w1
 ror w4, w4, w1

  add w11, w11, w10
 add w11, w11, w4
 ror w11, w11, #29
 add w2, w2, w11
 add w2, w2, w4
 add w1, w11, w4
 mov w0, #32
 sub w1, w0, w1
 ror w2, w2, w1

  add w12, w12, w11
 add w12, w12, w2
 ror w12, w12, #29
 add w3, w3, w12
 add w3, w3, w2
 add w1, w12, w2
 mov w0, #32
 sub w1, w0, w1
 ror w3, w3, w1

  add w13, w13, w12
 add w13, w13, w3
 ror w13, w13, #29
 add w4, w4, w13
 add w4, w4, w3
 add w1, w13, w3
 mov w0, #32
 sub w1, w0, w1
 ror w4, w4, w1

  add w14, w14, w13
 add w14, w14, w4
 ror w14, w14, #29
 add w2, w2, w14
 add w2, w2, w4
 add w1, w14, w4
 mov w0, #32
 sub w1, w0, w1
 ror w2, w2, w1

  add w15, w15, w14
 add w15, w15, w2
 ror w15, w15, #29
 add w3, w3, w15
 add w3, w3, w2
 add w1, w15, w2
 mov w0, #32
 sub w1, w0, w1
 ror w3, w3, w1

  add w16, w16, w15
 add w16, w16, w3
 ror w16, w16, #29
 add w4, w4, w16
 add w4, w4, w3
 add w1, w16, w3
 mov w0, #32
 sub w1, w0, w1
 ror w4, w4, w1

  add w17, w17, w16
 add w17, w17, w4
 ror w17, w17, #29
 add w2, w2, w17
 add w2, w2, w4
 add w1, w17, w4
 mov w0, #32
 sub w1, w0, w1
 ror w2, w2, w1

  add w18, w18, w17
 add w18, w18, w2
 ror w18, w18, #29
 add w3, w3, w18
 add w3, w3, w2
 add w1, w18, w2
 mov w0, #32
 sub w1, w0, w1
 ror w3, w3, w1

  add w19, w19, w18
 add w19, w19, w3
 ror w19, w19, #29
 add w4, w4, w19
 add w4, w4, w3
 add w1, w19, w3
 mov w0, #32
 sub w1, w0, w1
 ror w4, w4, w1

  add w20, w20, w19
 add w20, w20, w4
 ror w20, w20, #29
 add w2, w2, w20
 add w2, w2, w4
 add w1, w20, w4
 mov w0, #32
 sub w1, w0, w1
 ror w2, w2, w1

  add w21, w21, w20
 add w21, w21, w2
 ror w21, w21, #29
 add w3, w3, w21
 add w3, w3, w2
 add w1, w21, w2
 mov w0, #32
 sub w1, w0, w1
 ror w3, w3, w1

  add w22, w22, w21
 add w22, w22, w3
 ror w22, w22, #29
 add w4, w4, w22
 add w4, w4, w3
 add w1, w22, w3
 mov w0, #32
 sub w1, w0, w1
 ror w4, w4, w1

  add w23, w23, w22
 add w23, w23, w4
 ror w23, w23, #29
 add w2, w2, w23
 add w2, w2, w4
 add w1, w23, w4
 mov w0, #32
 sub w1, w0, w1
 ror w2, w2, w1

  add w24, w24, w23
 add w24, w24, w2
 ror w24, w24, #29
 add w3, w3, w24
 add w3, w3, w2
 add w1, w24, w2
 mov w0, #32
 sub w1, w0, w1
 ror w3, w3, w1

  add w25, w25, w24
 add w25, w25, w3
 ror w25, w25, #29
 add w4, w4, w25
 add w4, w4, w3
 add w1, w25, w3
 mov w0, #32
 sub w1, w0, w1
 ror w4, w4, w1

  add w26, w26, w25
 add w26, w26, w4
 ror w26, w26, #29
 add w2, w2, w26
 add w2, w2, w4
 add w1, w26, w4
 mov w0, #32
 sub w1, w0, w1
 ror w2, w2, w1

  add w27, w27, w26
 add w27, w27, w2
 ror w27, w27, #29
 add w3, w3, w27
 add w3, w3, w2
 add w1, w27, w2
 mov w0, #32
 sub w1, w0, w1
 ror w3, w3, w1

  add w28, w28, w27
 add w28, w28, w3
 ror w28, w28, #29
 add w4, w4, w28
 add w4, w4, w3
 add w1, w28, w3
 mov w0, #32
 sub w1, w0, w1
 ror w4, w4, w1

  add w29, w29, w28
 add w29, w29, w4
 ror w29, w29, #29
 add w2, w2, w29
 add w2, w2, w4
 add w1, w29, w4
 mov w0, #32
 sub w1, w0, w1
 ror w2, w2, w1

  add w30, w30, w29
 add w30, w30, w2
 ror w30, w30, #29
 add w3, w3, w30
 add w3, w3, w2
 add w1, w30, w2
 mov w0, #32
 sub w1, w0, w1
 ror w3, w3, w1


  add w5, w5, w30
 add w5, w5, w3
 ror w5, w5, #29
 add w4, w4, w5
 add w4, w4, w3
 add w1, w5, w3
 mov w0, #32
 sub w1, w0, w1
 ror w4, w4, w1


  add w6, w6, w5
 add w6, w6, w4
 ror w6, w6, #29
 add w2, w2, w6
 add w2, w2, w4
 add w1, w6, w4
 mov w0, #32
 sub w1, w0, w1
 ror w2, w2, w1

  add w7, w7, w6
 add w7, w7, w2
 ror w7, w7, #29
 add w3, w3, w7
 add w3, w3, w2
 add w1, w7, w2
 mov w0, #32
 sub w1, w0, w1
 ror w3, w3, w1

  add w8, w8, w7
 add w8, w8, w3
 ror w8, w8, #29
 add w4, w4, w8
 add w4, w4, w3
 add w1, w8, w3
 mov w0, #32
 sub w1, w0, w1
 ror w4, w4, w1

  add w9, w9, w8
 add w9, w9, w4
 ror w9, w9, #29
 add w2, w2, w9
 add w2, w2, w4
 add w1, w9, w4
 mov w0, #32
 sub w1, w0, w1
 ror w2, w2, w1

  add w10, w10, w9
 add w10, w10, w2
 ror w10, w10, #29
 add w3, w3, w10
 add w3, w3, w2
 add w1, w10, w2
 mov w0, #32
 sub w1, w0, w1
 ror w3, w3, w1

  add w11, w11, w10
 add w11, w11, w3
 ror w11, w11, #29
 add w4, w4, w11
 add w4, w4, w3
 add w1, w11, w3
 mov w0, #32
 sub w1, w0, w1
 ror w4, w4, w1

  add w12, w12, w11
 add w12, w12, w4
 ror w12, w12, #29
 add w2, w2, w12
 add w2, w2, w4
 add w1, w12, w4
 mov w0, #32
 sub w1, w0, w1
 ror w2, w2, w1

  add w13, w13, w12
 add w13, w13, w2
 ror w13, w13, #29
 add w3, w3, w13
 add w3, w3, w2
 add w1, w13, w2
 mov w0, #32
 sub w1, w0, w1
 ror w3, w3, w1

  add w14, w14, w13
 add w14, w14, w3
 ror w14, w14, #29
 add w4, w4, w14
 add w4, w4, w3
 add w1, w14, w3
 mov w0, #32
 sub w1, w0, w1
 ror w4, w4, w1

  add w15, w15, w14
 add w15, w15, w4
 ror w15, w15, #29
 add w2, w2, w15
 add w2, w2, w4
 add w1, w15, w4
 mov w0, #32
 sub w1, w0, w1
 ror w2, w2, w1

  add w16, w16, w15
 add w16, w16, w2
 ror w16, w16, #29
 add w3, w3, w16
 add w3, w3, w2
 add w1, w16, w2
 mov w0, #32
 sub w1, w0, w1
 ror w3, w3, w1

  add w17, w17, w16
 add w17, w17, w3
 ror w17, w17, #29
 add w4, w4, w17
 add w4, w4, w3
 add w1, w17, w3
 mov w0, #32
 sub w1, w0, w1
 ror w4, w4, w1

  add w18, w18, w17
 add w18, w18, w4
 ror w18, w18, #29
 add w2, w2, w18
 add w2, w2, w4
 add w1, w18, w4
 mov w0, #32
 sub w1, w0, w1
 ror w2, w2, w1

  add w19, w19, w18
 add w19, w19, w2
 ror w19, w19, #29
 add w3, w3, w19
 add w3, w3, w2
 add w1, w19, w2
 mov w0, #32
 sub w1, w0, w1
 ror w3, w3, w1

  add w20, w20, w19
 add w20, w20, w3
 ror w20, w20, #29
 add w4, w4, w20
 add w4, w4, w3
 add w1, w20, w3
 mov w0, #32
 sub w1, w0, w1
 ror w4, w4, w1

  add w21, w21, w20
 add w21, w21, w4
 ror w21, w21, #29
 add w2, w2, w21
 add w2, w2, w4
 add w1, w21, w4
 mov w0, #32
 sub w1, w0, w1
 ror w2, w2, w1

  add w22, w22, w21
 add w22, w22, w2
 ror w22, w22, #29
 add w3, w3, w22
 add w3, w3, w2
 add w1, w22, w2
 mov w0, #32
 sub w1, w0, w1
 ror w3, w3, w1

  add w23, w23, w22
 add w23, w23, w3
 ror w23, w23, #29
 add w4, w4, w23
 add w4, w4, w3
 add w1, w23, w3
 mov w0, #32
 sub w1, w0, w1
 ror w4, w4, w1

  add w24, w24, w23
 add w24, w24, w4
 ror w24, w24, #29
 add w2, w2, w24
 add w2, w2, w4
 add w1, w24, w4
 mov w0, #32
 sub w1, w0, w1
 ror w2, w2, w1

  add w25, w25, w24
 add w25, w25, w2
 ror w25, w25, #29
 add w3, w3, w25
 add w3, w3, w2
 add w1, w25, w2
 mov w0, #32
 sub w1, w0, w1
 ror w3, w3, w1

  add w26, w26, w25
 add w26, w26, w3
 ror w26, w26, #29
 add w4, w4, w26
 add w4, w4, w3
 add w1, w26, w3
 mov w0, #32
 sub w1, w0, w1
 ror w4, w4, w1

  add w27, w27, w26
 add w27, w27, w4
 ror w27, w27, #29
 add w2, w2, w27
 add w2, w2, w4
 add w1, w27, w4
 mov w0, #32
 sub w1, w0, w1
 ror w2, w2, w1

  add w28, w28, w27
 add w28, w28, w2
 ror w28, w28, #29
 add w3, w3, w28
 add w3, w3, w2
 add w1, w28, w2
 mov w0, #32
 sub w1, w0, w1
 ror w3, w3, w1

  add w29, w29, w28
 add w29, w29, w3
 ror w29, w29, #29
 add w4, w4, w29
 add w4, w4, w3
 add w1, w29, w3
 mov w0, #32
 sub w1, w0, w1
 ror w4, w4, w1

  add w30, w30, w29
 add w30, w30, w4
 ror w30, w30, #29
 add w2, w2, w30
 add w2, w2, w4
 add w1, w30, w4
 mov w0, #32
 sub w1, w0, w1
 ror w2, w2, w1




  add w5, w5, w30
 add w5, w5, w2
 ror w5, w5, #29
 add w3, w3, w5
 add w3, w3, w2
 add w1, w5, w2
 mov w0, #32
 sub w1, w0, w1
 ror w3, w3, w1

  add w6, w6, w5
 add w6, w6, w3
 ror w6, w6, #29
 add w4, w4, w6
 add w4, w4, w3
 add w1, w6, w3
 mov w0, #32
 sub w1, w0, w1
 ror w4, w4, w1

  add w7, w7, w6
 add w7, w7, w4
 ror w7, w7, #29
 add w2, w2, w7
 add w2, w2, w4
 add w1, w7, w4
 mov w0, #32
 sub w1, w0, w1
 ror w2, w2, w1

  add w8, w8, w7
 add w8, w8, w2
 ror w8, w8, #29
 add w3, w3, w8
 add w3, w3, w2
 add w1, w8, w2
 mov w0, #32
 sub w1, w0, w1
 ror w3, w3, w1

  add w9, w9, w8
 add w9, w9, w3
 ror w9, w9, #29
 add w4, w4, w9
 add w4, w4, w3
 add w1, w9, w3
 mov w0, #32
 sub w1, w0, w1
 ror w4, w4, w1

  add w10, w10, w9
 add w10, w10, w4
 ror w10, w10, #29
 add w2, w2, w10
 add w2, w2, w4
 add w1, w10, w4
 mov w0, #32
 sub w1, w0, w1
 ror w2, w2, w1

  add w11, w11, w10
 add w11, w11, w2
 ror w11, w11, #29
 add w3, w3, w11
 add w3, w3, w2
 add w1, w11, w2
 mov w0, #32
 sub w1, w0, w1
 ror w3, w3, w1

  add w12, w12, w11
 add w12, w12, w3
 ror w12, w12, #29
 add w4, w4, w12
 add w4, w4, w3
 add w1, w12, w3
 mov w0, #32
 sub w1, w0, w1
 ror w4, w4, w1

  add w13, w13, w12
 add w13, w13, w4
 ror w13, w13, #29
 add w2, w2, w13
 add w2, w2, w4
 add w1, w13, w4
 mov w0, #32
 sub w1, w0, w1
 ror w2, w2, w1

  add w14, w14, w13
 add w14, w14, w2
 ror w14, w14, #29
 add w3, w3, w14
 add w3, w3, w2
 add w1, w14, w2
 mov w0, #32
 sub w1, w0, w1
 ror w3, w3, w1

  add w15, w15, w14
 add w15, w15, w3
 ror w15, w15, #29
 add w4, w4, w15
 add w4, w4, w3
 add w1, w15, w3
 mov w0, #32
 sub w1, w0, w1
 ror w4, w4, w1

  add w16, w16, w15
 add w16, w16, w4
 ror w16, w16, #29
 add w2, w2, w16
 add w2, w2, w4
 add w1, w16, w4
 mov w0, #32
 sub w1, w0, w1
 ror w2, w2, w1

  add w17, w17, w16
 add w17, w17, w2
 ror w17, w17, #29
 add w3, w3, w17
 add w3, w3, w2
 add w1, w17, w2
 mov w0, #32
 sub w1, w0, w1
 ror w3, w3, w1

  add w18, w18, w17
 add w18, w18, w3
 ror w18, w18, #29
 add w4, w4, w18
 add w4, w4, w3
 add w1, w18, w3
 mov w0, #32
 sub w1, w0, w1
 ror w4, w4, w1

  add w19, w19, w18
 add w19, w19, w4
 ror w19, w19, #29
 add w2, w2, w19
 add w2, w2, w4
 add w1, w19, w4
 mov w0, #32
 sub w1, w0, w1
 ror w2, w2, w1

  add w20, w20, w19
 add w20, w20, w2
 ror w20, w20, #29
 add w3, w3, w20
 add w3, w3, w2
 add w1, w20, w2
 mov w0, #32
 sub w1, w0, w1
 ror w3, w3, w1

  add w21, w21, w20
 add w21, w21, w3
 ror w21, w21, #29
 add w4, w4, w21
 add w4, w4, w3
 add w1, w21, w3
 mov w0, #32
 sub w1, w0, w1
 ror w4, w4, w1

  add w22, w22, w21
 add w22, w22, w4
 ror w22, w22, #29
 add w2, w2, w22
 add w2, w2, w4
 add w1, w22, w4
 mov w0, #32
 sub w1, w0, w1
 ror w2, w2, w1

  add w23, w23, w22
 add w23, w23, w2
 ror w23, w23, #29
 add w3, w3, w23
 add w3, w3, w2
 add w1, w23, w2
 mov w0, #32
 sub w1, w0, w1
 ror w3, w3, w1

  add w24, w24, w23
 add w24, w24, w3
 ror w24, w24, #29
 add w4, w4, w24
 add w4, w4, w3
 add w1, w24, w3
 mov w0, #32
 sub w1, w0, w1
 ror w4, w4, w1

  add w25, w25, w24
 add w25, w25, w4
 ror w25, w25, #29
 add w2, w2, w25
 add w2, w2, w4
 add w1, w25, w4
 mov w0, #32
 sub w1, w0, w1
 ror w2, w2, w1

  add w26, w26, w25
 add w26, w26, w2
 ror w26, w26, #29
 add w3, w3, w26
 add w3, w3, w2
 add w1, w26, w2
 mov w0, #32
 sub w1, w0, w1
 ror w3, w3, w1

  add w27, w27, w26
 add w27, w27, w3
 ror w27, w27, #29
 add w4, w4, w27
 add w4, w4, w3
 add w1, w27, w3
 mov w0, #32
 sub w1, w0, w1
 ror w4, w4, w1

  add w28, w28, w27
 add w28, w28, w4
 ror w28, w28, #29
 add w2, w2, w28
 add w2, w2, w4
 add w1, w28, w4
 mov w0, #32
 sub w1, w0, w1
 ror w2, w2, w1

  add w29, w29, w28
 add w29, w29, w2
 ror w29, w29, #29
 add w3, w3, w29
 add w3, w3, w2
 add w1, w29, w2
 mov w0, #32
 sub w1, w0, w1
 ror w3, w3, w1

  add w30, w30, w29
 add w30, w30, w3
 ror w30, w30, #29
 add w4, w4, w30
 add w4, w4, w3
 add w1, w30, w3
 mov w0, #32
 sub w1, w0, w1
 ror w4, w4, w1



  ldp x0, x1, [sp], #16


  add w0, w0, w5
  add w1, w1, w6

  eor w0, w0, w1
 mov w5, #32
 sub w5, w5, w1
 ror w0, w0, w5
 add w0, w0, w7
 eor w1, w1, w0
 mov w5, #32
 sub w5, w5, w0
 ror w1, w1, w5
 add w1, w1, w8

  eor w0, w0, w1
 mov w5, #32
 sub w5, w5, w1
 ror w0, w0, w5
 add w0, w0, w9
 eor w1, w1, w0
 mov w5, #32
 sub w5, w5, w0
 ror w1, w1, w5
 add w1, w1, w10

  eor w0, w0, w1
 mov w5, #32
 sub w5, w5, w1
 ror w0, w0, w5
 add w0, w0, w11
 eor w1, w1, w0
 mov w5, #32
 sub w5, w5, w0
 ror w1, w1, w5
 add w1, w1, w12

  eor w0, w0, w1
 mov w5, #32
 sub w5, w5, w1
 ror w0, w0, w5
 add w0, w0, w13
 eor w1, w1, w0
 mov w5, #32
 sub w5, w5, w0
 ror w1, w1, w5
 add w1, w1, w14

  eor w0, w0, w1
 mov w5, #32
 sub w5, w5, w1
 ror w0, w0, w5
 add w0, w0, w15
 eor w1, w1, w0
 mov w5, #32
 sub w5, w5, w0
 ror w1, w1, w5
 add w1, w1, w16

  eor w0, w0, w1
 mov w5, #32
 sub w5, w5, w1
 ror w0, w0, w5
 add w0, w0, w17
 eor w1, w1, w0
 mov w5, #32
 sub w5, w5, w0
 ror w1, w1, w5
 add w1, w1, w18

  eor w0, w0, w1
 mov w5, #32
 sub w5, w5, w1
 ror w0, w0, w5
 add w0, w0, w19
 eor w1, w1, w0
 mov w5, #32
 sub w5, w5, w0
 ror w1, w1, w5
 add w1, w1, w20

  eor w0, w0, w1
 mov w5, #32
 sub w5, w5, w1
 ror w0, w0, w5
 add w0, w0, w21
 eor w1, w1, w0
 mov w5, #32
 sub w5, w5, w0
 ror w1, w1, w5
 add w1, w1, w22

  eor w0, w0, w1
 mov w5, #32
 sub w5, w5, w1
 ror w0, w0, w5
 add w0, w0, w23
 eor w1, w1, w0
 mov w5, #32
 sub w5, w5, w0
 ror w1, w1, w5
 add w1, w1, w24

  eor w0, w0, w1
 mov w5, #32
 sub w5, w5, w1
 ror w0, w0, w5
 add w0, w0, w25
 eor w1, w1, w0
 mov w5, #32
 sub w5, w5, w0
 ror w1, w1, w5
 add w1, w1, w26

  eor w0, w0, w1
 mov w5, #32
 sub w5, w5, w1
 ror w0, w0, w5
 add w0, w0, w27
 eor w1, w1, w0
 mov w5, #32
 sub w5, w5, w0
 ror w1, w1, w5
 add w1, w1, w28

  eor w0, w0, w1
 mov w5, #32
 sub w5, w5, w1
 ror w0, w0, w5
 add w0, w0, w29
 eor w1, w1, w0
 mov w5, #32
 sub w5, w5, w0
 ror w1, w1, w5
 add w1, w1, w30


  mov x30, xzr
  add x30, x30, w0, uxtw
  add x30, x30, x1, LSL #32
  mov x0, x30

  ldp x27, x28, [sp], #16
  ldp x25, x26, [sp], #16
  ldp x23, x24, [sp], #16
  ldp x21, x22, [sp], #16
  ldp x19, x20, [sp], #16

  ldp x29, x30, [sp], #16

  ret

.balign 8
constant_p: .word 0xb7e15163

.balign 8
constant_q: .word 0x9e3779b9
.text
.align 2
