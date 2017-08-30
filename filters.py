from PIL import Image, ImageFilter, ImageChops, ImageOps, ImageDraw, ImageFont
import numpy as np
import math
impath="wall.JPG"
im=Image.open(impath)
w, h = im.size
im=ImageOps.fit(im, [w//4,h//4], Image.NEAREST)
w, h = im.size
imarray = np.asarray(im).copy()
#print(imarray[i - 1:i + 1, n - 1:n + 1].reshape(1,4,3)[0][:])
def medianDeNoise(imarray,w,h):
    for i in range(1,h-1):
        for n in range(1,w-1):
            neighborsmatrix=np.asarray([imarray[i-1,n-1,:],imarray[i+1,n-1,:],imarray[i,n-1,:],imarray[i+1,n,:],imarray[i-1,n,:],imarray[i-1,n+1,:],imarray[i,n+1,:],imarray[i+1,n+1,:],]).reshape(1,8,3)
            imarray[i,n]=np.median(neighborsmatrix[0][:][:], axis=0)
    return imarray
def saturationIncrease(imarray, amt, w, h):
    #python implementation of http://alienryderflex.com/saturation.html
    r =.299
    g =.587
    b =.114
    for i in range(1,h-1):
        for n in range(1,w-1):
            rr,gg,bb=imarray[i,n]
            p=math.sqrt((rr**2*r)+(gg**2*g)+(gg**2*g))
            imarray[i,n]=[p+(rr-p)*amt,p+(gg-p)*amt,p+(bb-p)*amt]
            imarray[i,n]=np.clip(imarray[i,n],0,255)
    return imarray
#image = Image.fromarray(medianDeNoise(imarray,w,h), 'RGB')
image = Image.fromarray(saturationIncrease(imarray,1,w,h), 'RGB')
image.show()
