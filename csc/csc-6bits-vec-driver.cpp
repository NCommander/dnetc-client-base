// Copyright distributed.net 1997 - All Rights Reserved
// For use in distributed.net projects only.
// Any other distribution or use of this source violates copyright.
//
// $Log: csc-6bits-vec-driver.cpp,v $
// Revision 1.2  1999/12/09 13:13:20  cyp
// sync
//
// Revision 1.1.2.1  1999/12/09 04:56:48  sampo
// first few files of the altivec bitslicer for CSC.  note: this is known to be broken!  it will not work!  This is just the start.
// things that I still have to do:
// 1) write conversion routines for keyhi/keylo that take 128 bit vectors
// 2) move keyhi/keylo over to vectors instead of ulongs
// 3) any other errors made by code that assumes 64bit is the maximum bitslice?
//
// Revision 1.5  1999/11/01 17:25:51  cyp
// sync from release
//
// Revision 1.2.2.7  1999/10/30 15:02:27  remi
// Hrmm, I can't program in C :(
// if (blah & 15 != 0)
// 	slap(remi);
// if ((blah & 15) != 0)
// 	pets(remi);
//
// Revision 1.2.2.6  1999/10/24 23:54:54  remi
// Use Problem::core_membuffer instead of stack for CSC cores.
// Align frequently used memory to 16-byte boundary in CSC cores.
//
// Revision 1.2.2.5  1999/10/20 16:15:34  cyp
// added cast where compiler was complaining about potential underflow when
// assigning an int value to u8 var.
//
// Revision 1.2.2.4  1999/10/08 00:07:01  cyp
// made (mostly) all extern "C" {}
//
// Revision 1.2.2.3  1999/10/07 23:37:40  cyp
// changed '#elif CSC_BIT_64' to '#elif defined(CSC_BIT_64)' and changed an
// 'unsigned long' to 'ulong'
//
// Revision 1.2.2.2  1999/10/07 19:08:59  remi
// CSC_64_BITS patch
//
// Revision 1.2.2.1  1999/10/07 18:41:14  cyp
// sync'd from head
//
// Revision 1.2  1999/07/25 13:28:51  remi
// Fix for 64-bit processors.
//
// Revision 1.1  1999/07/23 02:43:06  fordbr
// CSC cores added
//
//

#include <stdio.h>
#include <assert.h>
#include <string.h>
#include "problem.h"
#include "convcsc.h"

#include "csc-common.h"

#if (!defined(lint) && defined(__showids__))
const char * PASTE(csc_6bits_driver_,CSC_SUFFIX) (void) {
return "@(#)$Id: csc-6bits-vec-driver.cpp,v 1.2 1999/12/09 13:13:20 cyp Exp $"; }
#endif

/*
static void printkey( ulong key[64], int n, bool tab )
{
  ulong k = 0;
  for( int i=0; i<64; i++ )
    if( key[i] & (1ul << n) )
      k |= (1ull << i);
  printf( "%s%016Lx\n", tab?"\t":"", k );
}
*/

// ------------------------------------------------------------------
#ifdef __cplusplus
extern "C" {
s32
PASTE(vec_csc_unit_func_,CSC_SUFFIX)
( RC5UnitWork *unitwork, u32 *timeslice, void *membuff );
}
#endif

s32
PASTE(vec_csc_unit_func_,CSC_SUFFIX)
( RC5UnitWork *unitwork, u32 *timeslice, void *membuff )
{
  // align buffer on a 16-byte boundary
  assert(sizeof(void*) == sizeof(unsigned long));
  char *membuffer = (char*)membuff;
  if( ((unsigned)membuffer & 15) != 0)
    membuffer = (char*)(((unsigned long)(membuffer+15) & ~((unsigned long)15)));

  //ulong key[2][64];
  ulong (*key)[2][64] = (ulong(*)[2][64])membuffer;
  membuffer += sizeof(*key);
  //ulong plain[64];
  ulong (*plain)[64] = (ulong(*)[64])membuffer;
  vulong (*vec_plain)[64] = (vulong(*)[64])membuffer;
  membuffer += sizeof(*vec_plain);
  //ulong cipher[64];
  ulong (*cipher)[64] = (ulong(*)[64])membuffer;
  vulong (*vec_cipher)[64] = (vulong(*)[64])membuffer;
  membuffer += sizeof(*vec_cipher);
  u8 keyB[8];

//#ifdef CSC_BIT_32
//  assert( sizeof(ulong) == 4);
//#elif defined(CSC_BIT_64)
//  assert( sizeof(ulong) == 8);
//#endif

  // convert the starting key from incrementable format
  // to CSC format
  u32 keyhi = unitwork->L0.hi;
  u32 keylo = unitwork->L0.lo;
  convert_key_from_inc_to_csc (&keyhi, &keylo);

  // convert plaintext, cyphertext and key to slice mode
  u32 pp = unitwork->plain.lo;
  u32 cc = unitwork->cypher.lo;
  u32 kk = keylo;
  u32 mask = 1;
  {
  for (int i=0; i<64; i++) {
    (*plain)[i].ui[0] = (pp & mask) ? _1 : _0;
	(*plain)[i].vec = vec_splat((*plain)[i].vec,0);
    (*cipher)[i].ui[0] = (cc & mask) ? _1 : _0;
	(*cipher)[i].vec = vec_splat((*cipher)[i].vec,0);
    (*key)[0][i].ui[0] = (kk & mask) ? _1 : _0;
	(*key)[0][i].vec = vec_splat((*key)[0][i].vec,0);
    if ((u32)(mask <<= 1) == 0) {
      pp = unitwork->plain.hi;
      cc = unitwork->cypher.hi;
      kk = keyhi;
      mask = 1;
    }
  }
  }
  memset( &((*key)[1]), 0, sizeof((*key)[1]) );

  // convert key to a stream of bytes
  keyB[0] = (u8)( (keyhi >> 24) & 0xFF );
  keyB[1] = (u8)( (keyhi >> 16) & 0xFF );
  keyB[2] = (u8)( (keyhi >>  8) & 0xFF );
  keyB[3] = (u8)( (keyhi >>  0) & 0xFF );
  keyB[4] = (u8)( (keylo >> 24) & 0xFF );
  keyB[5] = (u8)( (keylo >> 16) & 0xFF );
  keyB[6] = (u8)( (keylo >>  8) & 0xFF );
  keyB[7] = 0; // should be, we're looking for a 56-bit key

#if defined( CSC_BIT_32 )
#if __ALTIVEC__
  (*key)[0][csc_bit_order[0]].ui[0] = 0xAAAAAAAAul;
  (*key)[0][csc_bit_order[0]].vec = vec_splat((*key)[0][csc_bit_order[0]].vec,0);  
  (*key)[0][csc_bit_order[1]].ui[0] = 0xCCCCCCCCul;
  (*key)[0][csc_bit_order[1]].vec = vec_splat((*key)[0][csc_bit_order[0]].vec,0);
  (*key)[0][csc_bit_order[2]].ui[0] = 0xF0F0F0F0ul;
  (*key)[0][csc_bit_order[2]].vec = vec_splat((*key)[0][csc_bit_order[0]].vec,0);
  (*key)[0][csc_bit_order[3]].ui[0] = 0xFF00FF00ul;
  (*key)[0][csc_bit_order[3]].vec = vec_splat((*key)[0][csc_bit_order[0]].vec,0);
  (*key)[0][csc_bit_order[4]].ui[0] = 0xFFFF0000ul;
  (*key)[0][csc_bit_order[4]].vec = vec_splat((*key)[0][csc_bit_order[0]].vec,0);
  (*key)[0][csc_bit_order[5]].ui[0] = 0xFFFFFFFFul;
  (*key)[0][csc_bit_order[5]].ui[1] = 0x00000000ul;
  (*key)[0][csc_bit_order[5]].ui[2] = 0xFFFFFFFFul;
  (*key)[0][csc_bit_order[5]].ui[3] = 0x00000000ul;
  (*key)[0][csc_bit_order[6]].ui[0] = 0xFFFFFFFFul;
  (*key)[0][csc_bit_order[6]].ui[1] = 0xFFFFFFFFul;
  (*key)[0][csc_bit_order[6]].ui[2] = 0x00000000ul;
  (*key)[0][csc_bit_order[6]].ui[3] = 0x00000000ul;
  #define CSC_BITSLICER_BITS 13
#else
  (*key)[0][csc_bit_order[0+6]] = 0xAAAAAAAAul;
  (*key)[0][csc_bit_order[1+6]] = 0xCCCCCCCCul;
  (*key)[0][csc_bit_order[2+6]] = 0xF0F0F0F0ul;
  (*key)[0][csc_bit_order[3+6]] = 0xFF00FF00ul;
  (*key)[0][csc_bit_order[4+6]] = 0xFFFF0000ul;
  #define CSC_BITSLICER_BITS 11
#endif
#elif defined( CSC_BIT_64 )
  (*key)[0][csc_bit_order[0+6]] = CASTNUM64(0xAAAAAAAAAAAAAAAA);
  (*key)[0][csc_bit_order[1+6]] = CASTNUM64(0xCCCCCCCCCCCCCCCC);
  (*key)[0][csc_bit_order[2+6]] = CASTNUM64(0xF0F0F0F0F0F0F0F0);
  (*key)[0][csc_bit_order[3+6]] = CASTNUM64(0xFF00FF00FF00FF00);
  (*key)[0][csc_bit_order[4+6]] = CASTNUM64(0xFFFF0000FFFF0000);
  (*key)[0][csc_bit_order[5+6]] = CASTNUM64(0xFFFFFFFF00000000);
  #define CSC_BITSLICER_BITS 12
#endif

  u32 nbits = CSC_BITSLICER_BITS; 
  while (*timeslice > (1ul << nbits)) nbits++;

  // Zero out all the bits that are to be varied
  for( int i=0; i<6; i++ ) {
    int n = csc_bit_order[i];
    (*key)[0][n].ui[0] = _0;
    (*key)[0][n].vec = vec_splat((*key)[0][n].vec,0);    
    keyB[7-n/8] &= (u8)(~(1 << (n%8)));
  }
  {
  for (u32 i=0; i<nbits-CSC_BITSLICER_BITS; i++) {
    int n = csc_bit_order[i+CSC_BITSLICER_BITS];
    (*key)[0][n].ui[0] = _0;
    (*key)[0][n].vec = vec_splat((*key)[0][n].vec,0);    
    keyB[7-n/8] &= (u8)(~(1 << (n%8)));
  }
  }
  
  // now we iterates, checking (32|64)*2^6 keys each time
  // we call cscipher_bitslicer()
  vulong result;
  u32 bkey = 0;
  for(u32 i=0; i < 64; i++) {
  	(*vec_plain)[i]  = (*plain[i]).vec;
  	(*vec_cipher)[i] = (*cipher[i]).vec;
  }
  for( ;; ) {
    //printkey( key[0], 17, 0 );
    result = PASTE(vec_cscipher_bitslicer_,CSC_SUFFIX) ( *key, keyB, *vec_plain, *vec_cipher, membuffer );
    if( vec_any_ne(result,(vulong)(0)) )
      break;
    if( ++bkey >= (1ul << (nbits - CSC_BITSLICER_BITS) ) )
      break;
    // Update the key
    u32 i = 0;
    while( !(bkey & (1 << i)) ) i++;
    i = csc_bit_order[i+CSC_BITSLICER_BITS];
    (*key)[0][i].vec = vec_xor((*key)[0][i].vec,(vulong)(_1));
    keyB[7-i/8] ^= (u8)(1 << (i%8));
  }

  // have we found something ?
  if( vec_any_ne(result,(vulong)(0)) ) {

    // which one is the good key ?
    // search the first bit set to 1 in result
    int numkeyfound;
    vector_union result_union;
    result_union.vec = result;
    vector unsigned char shift = vec_splat_u8(1);
    for( numkeyfound=0; result_union.ui[0] != 1; numkeyfound++, result = vec_sll(result_union.vec,shift));

    // convert winning key from slice mode to CSC format
    // (bits 0..7 should be set to zero)
    keylo = keyhi = 0;
    for( int j=8; j<64; j++ )
      if( j<32 ) {
	keylo |= (((*key)[0][j].ui[0] >> numkeyfound) & 1) << j;
	keylo |= (((*key)[0][j].ui[1] >> numkeyfound) & 1) << j;
	keylo |= (((*key)[0][j].ui[2] >> numkeyfound) & 1) << j;
	keylo |= (((*key)[0][j].ui[3] >> numkeyfound) & 1) << j;
	}
      else {
	keyhi |= (((*key)[0][j].ui[0] >> numkeyfound) & 1) << (j-32);
	keyhi |= (((*key)[0][j].ui[1] >> numkeyfound) & 1) << (j-32);
	keyhi |= (((*key)[0][j].ui[2] >> numkeyfound) & 1) << (j-32);
	keyhi |= (((*key)[0][j].ui[3] >> numkeyfound) & 1) << (j-32);
	}

    // convert key from CSC format to incrementable format
    convert_key_from_csc_to_inc( &keyhi, &keylo );

    if( keylo < unitwork->L0.lo )
      *timeslice = unitwork->L0.lo - keylo;
    else
      *timeslice = keylo - unitwork->L0.lo;
    
    unitwork->L0.lo = keylo;
    unitwork->L0.hi = keyhi;

    return RESULT_FOUND;

  } else {

    *timeslice = (1ul << nbits);
    unitwork->L0.lo += 1 << nbits; // Increment lower 32 bits
    if (unitwork->L0.lo < (u32)(1 << nbits) )
      unitwork->L0.hi++; // Carry to high 32 bits if needed

    return RESULT_NOTHING;
  }
}