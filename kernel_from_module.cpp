#include <cstdio>
#include <vector>
#include <string>
#include <stdexcept>
#include <hip/hip_runtime.h>

// loads and runs a kernel from a module file, which is passed as a program argument
int main(int argc, const char** argv){
  if(argc != 2){
    printf("usage: %s %s\n", argv[0], "<module_file.co>");
    return 1;
  }
  const char* module_file_name = argv[1];

  constexpr int size = 64; // we're just going to run a single workgroup of one wavefront
  
  int* int_array;
  hipMalloc(&int_array, size * sizeof(int));
  
  hipModule_t module;
  auto hip_result = hipModuleLoad(&module, module_file_name);
  if(hip_result != hipSuccess){
    std::string message("failed to load module ");
    message += module_file_name;
    throw std::runtime_error(message);
  }
  hipFunction_t function;
  hip_result = hipModuleGetFunction(&function, module, "_Z6kernelPii");
  if(hip_result != hipSuccess){
    std::string message("failed to load kernel \"kernel\" from module gfx906.co");
    throw std::runtime_error(message);
  }
  
  struct {
    int* int_array;
    int size;
  } kernel_args;
  kernel_args.int_array = int_array;
  kernel_args.size = size;
  size_t kernel_args_size = sizeof(kernel_args);
  void* kernel_args_wrapper[] = { HIP_LAUNCH_PARAM_BUFFER_POINTER, &kernel_args,
				  HIP_LAUNCH_PARAM_BUFFER_SIZE, &kernel_args_size,
				  HIP_LAUNCH_PARAM_END };
  hip_result = hipModuleLaunchKernel(function,
				     1, 0, 0,
				     size, 0, 0,
				     0, 0, nullptr,
				     kernel_args_wrapper);
  if(hip_result != hipSuccess){
    std::string message("failed to run module gfx906.co");
    throw std::runtime_error(message);
  }
  
  hipDeviceSynchronize();
  std::vector<int> results(size);
  for(auto& r: results){
    printf("%d  ", r);
  }
  printf("\n\n");
  hipMemcpy(results.data(), int_array, size * sizeof(int), hipMemcpyDeviceToHost);
  for(auto& r: results){
    printf("%d  ", r);
  }
  printf("\n");
}
