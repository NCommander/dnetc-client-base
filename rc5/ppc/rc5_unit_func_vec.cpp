#include "problem.h"

extern "C" {
int crunch_vec( RC5UnitWork *work, unsigned long iterations ); /* asm */
int crunch_allitnil( RC5UnitWork *, unsigned long iterations); /* asm */
s32 rc5_unit_func_vec( RC5UnitWork *, u32 *timeslice, void *); /* this */
u32 rc5_unit_func_vec_compat( RC5UnitWork *, u32 iterations ); /* this */
}

u32 rc5_unit_func_vec_compat( RC5UnitWork *work, u32 iterations )
{
  u32 kiter = 0; /* keys processed so far */
  do 
  {
    kiter += crunch_vec(work, iterations-kiter);
    if (kiter < iterations)
    {
      if (crunch_allitnil(work,1) == 0) 
        break;
      kiter++;
    }
  } while (kiter < iterations);
  return kiter;
}  

s32 rc5_unit_func_vec( RC5UnitWork *work, u32 *timeslice, void *savstate)
{
  u32 kiter = rc5_unit_func_vec_compat( work, *timeslice );
  savstate = savstate; /* unused. shaddup compiler */

  if (*timeslice == kiter) 
     return RESULT_WORKING;
  if (*timeslice < kiter) {
    *timeslice = kiter;
    return RESULT_FOUND;
  }
  /* shouldn't happen with this core */
  *timeslice = kiter;
  return -1; /* error */
}