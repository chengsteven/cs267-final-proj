# Load CUDA using the following command
# module load cuda
#
CC = nvcc
CFLAGS = -O3 #-arch=compute_35 -code=sm_35 -D_FORCE_INLINES
NVCCFLAGS = -O3 #-arch=compute_35 -code=sm_35 -D_FORCE_INLINES --use_fast_math
LIBS = 

TARGETS = aes_serial aes_parallel

all:	$(TARGETS)

aes_serial: aes_serial.o aes_common.o
	$(CC) -o $@ $(LIBS) aes_serial.o aes_common.o
aes_parallel: aes_parallel.o aes_common.o
	$(CC) -o $@ $(NVCCLIBS) aes_parallel.o aes_common.o


aes_serial.o: aes_serial.cu aes_common.h
	$(CC) -c $(CFLAGS) aes_serial.cu
aes_parallel.o: aes_parallel.cu aes_common.h
	$(CC) -c $(NVCCFLAGS) aes_parallel.cu
aes_common.o: aes_common.cu aes_common.h
	$(CC) -c $(CFLAGS) aes_common.cu

clean:
	rm -f *.o $(TARGETS) *.stdout *.txt
