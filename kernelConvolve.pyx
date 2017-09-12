import numpy as np
cimport numpy as np
cimport cython
@cython.boundscheck(False) # turn off bounds-checking for entire function
def accumulate(arr1, arr2):
    accummat=np.empty(arr1.shape)
    cdef Py_ssize_t i,n
    print(arr2)
    for i in range(0,arr1.shape[0]):
        for n in range(0,arr1.shape[1]):
            accummat[i,n]=arr1[i,n]*arr2[i,n]
    return np.sum(accummat)


def kernelConvolve(array, kernel, edgetype):
    kernsize=kernel.shape
    a=np.empty(kernsize)
    half=kernsize[0]//2
    print(half)
    for i in range(half,array.shape[0]-half):
        for n in range(half,array.shape[1]-half):
            a=array[i-half:i+half,n-half:n+half]
            array[i,n]=accumulate(kernel, a)
    #print(accumulate(np.array([[-1,-1,-1],[-1,9,-1],[-1,-1,-1]]), np.array([[-1,-1,-1],[-1,9,-1],[-1,-1,-1]])))
    return array
