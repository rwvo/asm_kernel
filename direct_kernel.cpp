#include <cstdio>
#include <vector>
#include <hip/hip_runtime.h>

__global__ void kernel(int* args, int size){
  int idx = blockIdx.x * blockDim.x + threadIdx.x;
  if(idx < size){
    args[idx] = idx;
  }
}


int main(){
  constexpr int size = 64;
  
  int* args;
  hipMalloc(&args, size * sizeof(int));
  hipLaunchKernelGGL(kernel, 1, size, 0, 0, args, size);
  hipDeviceSynchronize();
  std::vector<int> results(size);
  for(auto& r: results){
    printf("%d  ", r);
  }
  printf("\n\n");
  hipMemcpy(results.data(), args, size * sizeof(int), hipMemcpyDeviceToHost);
  for(auto& r: results){
    printf("%d  ", r);
  }
  printf("\n");
}
