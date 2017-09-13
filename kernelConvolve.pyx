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
    cdef int sum
    sum=accummat.sum(dtype=int)
    if(sum>255):
        sum=255
    elif(sum<0):
        sum=0
    return sum

def extendEdges(array,times):
    #adding edges to array
    for i in range(0,times):
        array=np.vstack((np.array([array[0,:]]),array,np.array([array[-1,:]])))
        array=np.hstack((np.array([array[:,0]]).reshape(array.shape[0],1,3),array,np.array([array[:,-1]]).reshape(array.shape[0],1,3)))
    return array

def kernelConvolve(array, kernel):
    kernsize=kernel.shape
    half=kernsize[0]//2
    newarray=np.array(array).astype(np.uint8)
    array=extendEdges(array,half)
    a=np.empty(kernsize).astype(np.uint16)
    cdef Py_ssize_t i,n
    if(len(newarray.shape)==2):
        for i in range(0,newarray.shape[0]):
            for n in range(0,newarray.shape[1]):
                a=array[(i+1)-half:(i+1)+half+1,(n+1)-half:(n+1)+half+1]
                newarray[i,n]=accumulate(kernel, a)

    if(len(newarray.shape)==3):
        for i in range(0,newarray.shape[0]):
            for n in range(0,newarray.shape[1]):
                a=array[(i+1)-half:(i+1)+half+1,(n+1)-half:(n+1)+half+1]
                #print(a, a[:,:,0])
                newarray[i,n][0]=accumulate(kernel, a[:,:,0])
                newarray[i,n][1]=accumulate(kernel, a[:,:,1])
                newarray[i,n][2]=accumulate(kernel, a[:,:,2])
    return np.array(np.clip(newarray,0,255)).astype(np.uint8)
