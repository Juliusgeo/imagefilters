import numpy as np
cimport numpy as np
cimport cython
@cython.boundscheck(False) # turn off bounds-checking for entire function

def sharpen(imarray, int w, int h):
    neimat=np.empty([8,3])
    cdef Py_ssize_t i,n
    r=9
    for i in range(1,(h-1)):
        for n in range(1,(w-1)):
            neimat[0]=imarray[i-1,n-1,:]
            neimat[1]=imarray[i+1,n-1,:]
            neimat[2]=imarray[i,n-1,:]
            neimat[3]=imarray[i+1,n,:]
            neimat[4]=imarray[i-1,n,:]
            neimat[5]=imarray[i-1,n+1,:]
            neimat[6]=imarray[i,n+1,:]
            neimat[7]=imarray[i+1,n+1,:]
            ne=np.sum(neimat,axis=0)
            sharp=[(r*imarray[i,n,0])-ne[0],(r*imarray[i,n,1])-ne[1],(r*imarray[i,n,2])-ne[2]]
            sharp=np.clip(sharp,0,255)
            imarray[i,n,:][0]=sharp[0]
            imarray[i,n,:][1]=sharp[1]
            imarray[i,n,:][2]=sharp[2]
    return np.array(imarray).astype(np.uint8)
