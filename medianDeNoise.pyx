import numpy as np
cimport numpy as np
cimport cython
@cython.boundscheck(False) # turn off bounds-checking for entire function
def fassum(np.uint8_t[:] arr):
    cdef np.uint16_t sum
    sum=0
    for i in xrange(0,len(arr)):
        sum=sum+arr[i]
    return sum

def fasmean(np.uint8_t[:,:] arr):
    cdef np.uint8_t[:] m
    m=np.empty([3]).astype(np.uint8)
    m[0]=fassum(arr[:,0])//8
    m[1]=fassum(arr[:,1])//8
    m[2]=fassum(arr[:,2])//8
    return m

def medianDeNoise(np.uint8_t[:,:,:] imarray, int w, int h):
    cdef np.uint8_t[:,:] neimat
    neimat=np.empty([8,3],dtype=np.uint8)
    cdef np.uint8_t[:] mean
    cdef int i,n
    for i in range(1,h-1):
        for n in range(1,w-1):
            neimat[0]=imarray[i-1,n-1,:]
            neimat[1]=imarray[i+1,n-1,:]
            neimat[2]=imarray[i,n-1,:]
            neimat[3]=imarray[i+1,n,:]
            neimat[4]=imarray[i-1,n,:]
            neimat[5]=imarray[i-1,n+1,:]
            neimat[6]=imarray[i,n+1,:]
            neimat[7]=imarray[i+1,n+1,:]
            #mean=np.mean(np.array(neimat),axis=0).astype(np.uint8)
            mean=np.asarray(fasmean(neimat)).astype(np.uint8)
            imarray[i,n,:][0]=mean[0]
            imarray[i,n,:][1]=mean[1]
            imarray[i,n,:][2]=mean[2]
    return np.asarray(imarray,dtype=np.uint8)
