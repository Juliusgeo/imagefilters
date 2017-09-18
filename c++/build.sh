g++ -g $(pkg-config --cflags --libs opencv) KernelConvolve.cpp -o KernelConvolve.out
time ./KernelConvolve.out