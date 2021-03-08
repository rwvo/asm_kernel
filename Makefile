CXX = hipcc
CXX_OPTS = 
ARCH = gfx906

test:

all: direct_kernel ${ARCH}.asm.co ${ARCH}.mod.co kernel_from_module

direct_kernel: direct_kernel.cpp
	${CXX} ${CXX_OPTS} -save-temps -o $@ $<

direct_kernel-hip-amdgcn-amd-amdhsa-${ARCH}.s: direct_kernel.cpp
	${CXX} ${CXX_OPTS} -save-temps -o direct_kernel $<

${ARCH}.s: direct_kernel-hip-amdgcn-amd-amdhsa-${ARCH}.s
	mv direct_kernel-hip-amdgcn-amd-amdhsa-${ARCH}.s ${ARCH}.s
	rm -f direct_kernel-* *.hipfb

${ARCH}.asm.co: ${ARCH}.s
	/opt/rocm/llvm/bin/clang -x assembler -target amdgcn-amd-amdhsa -mcpu=${ARCH} -o ${ARCH}.asm.co ${ARCH}.s

${ARCH}.mod.co: direct_kernel.cpp
	${CXX} ${CXX_OPTS} --cuda-device-only -c -o $@ $<

kernel_from_module: kernel_from_module.cpp
	${CXX} ${CXX_OPTS} -o $@ $<

test: direct_kernel kernel_from_module ${ARCH}.asm.co ${ARCH}.mod.co
	./direct_kernel
	./kernel_from_module ${ARCH}.asm.co
	./kernel_from_module ${ARCH}.mod.co

clean:
	rm -f direct_kernel kernel_from_module direct_kernel-* *.hipfb gfx906.s *.co
