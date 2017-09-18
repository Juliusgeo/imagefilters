g++ $(pkg-config --cflags --libs opencv) KernelConvolve.cpp -o KernelConvolve
time ./KernelConvolve