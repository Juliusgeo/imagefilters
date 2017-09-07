import numpy as np
cimport numpy as np
cimport cython
@cython.boundscheck(False) # turn off bounds-checking for entire function

def fassum(np.int16_t[:] arr):
    cdef np.int16_t sum
    sum=0
    for i in xrange(0,len(arr)):
        sum=sum+arr[i]
    return sum
def clip(arr):
    for i in xrange(0,len(arr)):
        if arr[i] >255:
            arr[i]=255
        elif arr[i] <0:
            arr[i]=0
    return arr

def neimatComp(filt, imarr):
    cdef np.uint16_t[:] ne=np.array([0,0,0]).astype(np.uint16)
    ne[0]=filt*imarr[0]
    ne[1]=filt*imarr[1]
    ne[2]=filt*imarr[2]
    print(ne)
    return np.array(clip(ne)).astype(np.uint8)

def sharpen(np.uint8_t[:,:,:] imarray, int w, int h):
    cdef np.int16_t[:,:] neimat
    neimat=np.empty([8,3],dtype=np.int16)
    cdef np.uint8_t[:] sharp
    cdef Py_ssize_t i,n
    cdef np.uint8_t[:] filter
    filter=np.asarray([-1,-1,-1,-1,-1,-1,-1,-1,9]).astype(np.uint8)
    for i in range(1,h-1):
        for n in range(1,w-1):
            neimat[0]=neimatComp(filter[0],imarray[i-1,n-1,:])
            #neimat[1]=imarray[i+1,n-1,:]*filter[1]
            #neimat[2]=imarray[i,n-1,:]*filter[2]
            #neimat[3]=imarray[i+1,n,:]*filter[3]
            #neimat[4]=imarray[i-1,n,:]*filter[4]
            #neimat[5]=imarray[i-1,n+1,:]*filter[5]
            #neimat[6]=imarray[i,n+1,:]*filter[6]
            #neimat[7]=imarray[i+1,n+1,:]*filter[7]
            #neimat[8]=imarray[i,n,:]*filter[8]
            #mean=np.mean(np.array(neimat),axis=0).astype(np.uint8)
            sharp=np.clip([fassum(neimat[:,0]),fassum(neimat[:,1]),fassum(neimat[:,2])],0,255).astype(np.int8)
            imarray[i,n,:][0]=sharp[0]
            imarray[i,n,:][1]=sharp[1]
            imarray[i,n,:][2]=sharp[2]
    return np.asarray(imarray,dtype=np.uint8)
