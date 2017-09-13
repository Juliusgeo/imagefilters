import numpy as np
cimport numpy as np
cimport cython
def accumulate(arr1, arr2):
    arr2=arr2.astype(int)
    accummat=np.empty(arr1.shape).astype(int)
    cdef Py_ssize_t i,n
    for i in range(0,arr1.shape[0]):
        for n in range(0,arr1.shape[1]):
            accummat[i,n]=arr1[i,n]*arr2[i,n]
    #print(arr2, accummat, arr1.dtype, arr2.dtype, sum)
    cdef int sum
    sum=accummat.sum(dtype=int)
    if(sum>255):
        sum=255
    elif(sum<0):
        sum=0
    return sum


def kernelConvolve(array, kernel):
    kernsize=kernel.shape
    newarray=np.array(array).astype(np.uint8)
    a=np.empty(kernsize).astype(np.uint16)
    half=kernsize[0]//2
    cdef Py_ssize_t i,n

    if(len(array.shape)==2):
        for i in range(half,array.shape[0]-half):
            #if(n>1): break
            for n in range(half,array.shape[1]-half):
                a=array[i-half:i+half+1,n-half:n+half+1]
                #print(a)
                newarray[i,n]=accumulate(kernel, a)
                #print(array[i,n])

    if(len(array.shape)==3):
        for i in range(half,array.shape[0]-half):
            #if(n>1): break
            for n in range(half,array.shape[1]-half):
                a=array[i-half:i+half+1,n-half:n+half+1]
                #print(a, a[:,:,0])
                newarray[i,n][0]=accumulate(kernel, a[:,0])
                newarray[i,n][1]=accumulate(kernel, a[:,1])
                newarray[i,n][2]=accumulate(kernel, a[:,2])
    #print(accumulate(np.array([[-1,-1,-1],[-1,9,-1],[-1,-1,-1]]), np.array([[-1,-1,-1],[-1,9,-1],[-1,-1,-1]])))
    return np.array(np.clip(newarray,0,255)).astype(np.uint8)
