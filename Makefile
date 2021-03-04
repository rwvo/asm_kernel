all: direct_kernel gfx906.asm.co kernel_from_module

direct_kernel: direct_kernel.cpp
	hipcc -save-temps -o $@ $<

gfx906.s: direct_kernel
	mv direct_kernel-hip-amdgcn-amd-amdhsa-gfx906.s gfx906.s
	rm -f direct_kernel-* *.hipfb

gfx906.asm.co: gfx906.s
	/opt/rocm/llvm/bin/clang -x assembler -target amdgcn-amd-amdhsa -mcpu=gfx906 -o gfx906.asm.co gfx906.s

gfx906.mod.co: direct_kernel.cpp
	hipcc --cuda-device-only -c -o $@ $<

kernel_from_module: kernel_from_module.cpp
	hipcc -o $@ $<

test: direct_kernel kernel_from_module gfx906.asm.co gfx906.mod.co
	./direct_kernel
	./kernel_from_module gfx906.asm.co
	./kernel_from_module gfx906.mod.co

clean:
	rm -f direct_kernel kernel_from_module direct_kernel-* *.hipfb *.s *.co
