from PIL import Image, ImageFilter, ImageChops, ImageOps, ImageDraw, ImageFont
import numpy as np
import math
import os
from medianDeNoise import medianDeNoise
from kernelConvolve import kernelConvolve
impath="Lenna.png"
im=Image.open(impath)
w, h = im.size
#im=ImageOps.fit(im, [w//4,h//4], Image.NEAREST)
#w, h = im.size
imarray = np.asarray(im.copy()).astype(np.uint8).reshape(h,w,3)
#imarray = np.asarray(im.convert("L")).copy().astype(np.uint8).reshape(h,w)
def saturationIncrease(imarray, amt, w, h):
    #python implementation of http://alienryderflex.com/saturation.html
    r =.299
    g =.587
    b =.114
    for i in range(1,h-1):
        for n in range(1,w-1):
            rr,gg,bb=imarray[i,n]
            p=math.sqrt((rr**2*r)+(gg**2*g)+(gg**2*g))
            imarray[i,n]=np.clip([p+(rr-p)*amt,p+(gg-p)*amt,p+(bb-p)*amt],0,255)
    return imarray
#image = Image.fromarray(medianDeNoise(imarray,w,h), 'RGB')
#image = Image.fromarray(saturationIncrease(imarray,3,w,h), 'RGB')
#image = Image.fromarray(sharpen(imarray,w,h), 'RGB')
kernel=np.array([[-1,-1,-1],
[-1,10,-1],
[-1,-1,-1]])
imarray=kernelConvolve(imarray, kernel)
image = Image.fromarray(imarray, 'RGB')
image.show()
#image.format="PNG"
#file, ext = os.path.splitext("Lenna.jpg")
#image.save(file+"filtered.png","PNG")
