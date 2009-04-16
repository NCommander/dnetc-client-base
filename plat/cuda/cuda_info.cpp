/*
 * Copyright distributed.net 2009 - All Rights Reserved
 * For use in distributed.net projects only.
 * Any other distribution or use of this source violates copyright.
 *
 * $Id: cuda_info.cpp,v 1.2 2009/04/07 09:23:31 andreasb Exp $
*/

#include "cuda_info.h"
#include "cuda_setup.h"

#include <stdio.h>
#include <cuda_runtime.h>

// returns -1 if not supported
// returns 0 if no supported GPU was found
int GetNumberOfDetectedCUDAGPUs()
{
  static int gpucount = -123;

  if (gpucount == -123) {
    gpucount = -1;
    if (InitializeCUDA() == 0) {
      cudaDeviceProp deviceProp;
      cudaError_t rc = cudaGetDeviceCount(&gpucount);
      if (rc != cudaSuccess) {
        gpucount = -1;
      } else {
        rc = cudaGetDeviceProperties(&deviceProp, 0); /* Only supports the first device */
        if (rc != cudaSuccess || (deviceProp.major == 9999 && deviceProp.minor == 9999))
          gpucount = 0;
      }
    }
  }

  return gpucount;
}

long GetRawCUDAGPUID(const char **cpuname)
{
  static char namebuf[40];
  static int cpucount;

  namebuf[0] = '\0';
  if (cpuname)
    *cpuname = &namebuf[0];

  if (GetNumberOfDetectedCUDAGPUs() >= 0) {
    cudaDeviceProp deviceProp;
    cudaError_t rc = cudaGetDeviceProperties(&deviceProp, 0); /* Only supports the first device */
    if (rc == cudaSuccess) {
      snprintf(namebuf, sizeof(namebuf), "%.29s (%d MPs)",
               deviceProp.name, deviceProp.multiProcessorCount);

      // FIXME: we need some ID to distinguish different cards
      // for now the register count is enough to decide whether 256-thread cores are feasible
      return deviceProp.regsPerBlock;
    }
  }
  return -1;
}

// returns the frequency in MHz, or 0.
unsigned int GetCUDAGPUFrequency()
{
  unsigned int freq = 0;
  if (GetNumberOfDetectedCUDAGPUs() > 0) {
    cudaDeviceProp deviceProp;
    cudaError_t rc = cudaGetDeviceProperties(&deviceProp, 0); /* Only supports the first device */
    if (rc == cudaSuccess && (deviceProp.major != 9999 && deviceProp.minor != 9999))
      freq = deviceProp.clockRate / 1000;
  }
  return freq;
}