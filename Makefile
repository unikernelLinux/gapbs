# See LICENSE.txt for license details.

CXX_FLAGS += -O3 -Wall -ggdb -mno-red-zone -mcmodel=kernel
PAR_FLAG = -fno-openmp

ifneq (,$(findstring icpc,$(CXX)))
	PAR_FLAG = -openmp
endif

ifneq (,$(findstring sunCC,$(CXX)))
	CXX_FLAGS = -std=c++11 -xO3 -m64 -xtarget=native
	PAR_FLAG = -xopenmp
endif

ifneq ($(SERIAL), 1)
	CXX_FLAGS += $(PAR_FLAG)
endif

KERNELS = bc bfs cc cc_sv pr pr_spmv sssp tc
SUITE = $(KERNELS) converter

.PHONY: all build-gapbs

DIR=${CURDIR}/..
GCC_LIB=$(DIR)/gcc-build-cpp/x86_64-pc-linux-gnu/libgcc/
LC_DIR=$(DIR)/glibc-build/
CRT_LIB=$(LC_DIR)csu/
C_LIB=$(LC_DIR)libc.a
PTHREAD_LIB=$(LC_DIR)nptl/libpthread.a
RT_LIB=$(LC_DIR)rt/librt.a
MATH_LIB=$(LC_DIR)math/libm.a
CRT_STARTS=$(CRT_LIB)crt1.o $(CRT_LIB)crti.o $(GCC_LIB)crtbeginT.o
CRT_ENDS=$(GCC_LIB)crtend.o $(CRT_LIB)crtn.o
SYS_LIBS=$(GCC_LIB)libgcc.a #$(GCC_LIB)libgcc_eh.a
CPP_LIB=$(DIR)/gcc-build-cpp/x86_64-pc-linux-gnu/libstdc++-v3/src/.libs/libstdc++.a


build-gapbs:
	- rm -rf gapbs.ukl UKL.a
	g++ -c -o bfs_tmp.o src/bfs.cc $(CXX_FLAGS)
	g++ -c -o sssp_tmp.o src/sssp.cc $(CXX_FLAGS)
	g++ -c -o pr_tmp.o src/pr.cc $(CXX_FLAGS)
	g++ -c -o cc_tmp.o src/cc.cc $(CXX_FLAGS)
	g++ -c -o bc_tmp.o src/bc.cc $(CXX_FLAGS)
	g++ -c -o tc_tmp.o src/tc.cc $(CXX_FLAGS)
	g++ -c -o main_tmp.o src/main.cc $(CXX_FLAGS)
	ld -r -o gapbs.ukl --allow-multiple-definition $(CRT_STARTS) main_tmp.o \
		bfs_tmp.o sssp_tmp.o pr_tmp.o cc_tmp.o bc_tmp.o tc_tmp.o \
		--start-group --whole-archive $(CPP_LIB) $(MATH_LIB) $(PTHREAD_LIB) \
		$(C_LIB) --no-whole-archive $(SYS_LIBS) --end-group $(CRT_ENDS)
	rm -rf *_tmp.o
	ar cr UKL.a gapbs.ukl ../undefined_sys_hack.o
	objcopy --prefix-symbols=ukl_ UKL.a
	objcopy --redefine-syms=../redef_sym_names UKL.a
	cp UKL.a ../

all: $(SUITE)

% : src/%.cc src/*.h
	$(CXX) $(CXX_FLAGS) $< -o $@

# Testing
include test/test.mk

# Benchmark Automation
include benchmark/bench.mk


.PHONY: clean
clean:
	rm -f $(SUITE) test/out/*

