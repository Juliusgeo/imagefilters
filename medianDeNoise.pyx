import numpy as np
cimport numpy as np
cimport cython
@cython.boundscheck(False) # turn off bounds-checking for entire function

def medianDeNoise(long[:,:,:] imarray, int w, int h):
    cdef long[:,:] neighborsmatrix
    cdef long[:] mean
    for i in range(1,h-1):
        for n in range(1,w-1):
            neighborsmatrix=np.array([imarray[i-1,n-1,:],imarray[i+1,n-1,:],imarray[i,n-1,:],imarray[i+1,n,:],imarray[i-1,n,:],imarray[i-1,n+1,:],imarray[i,n+1,:],imarray[i+1,n+1,:]])
            mean=np.mean(np.array(neighborsmatrix),axis=0).astype(long)
            imarray[i,n,:][0]=mean[0]
            imarray[i,n,:][1]=mean[1]
            imarray[i,n,:][2]=mean[2]
    return np.asarray(imarray,dtype=np.uint8)
