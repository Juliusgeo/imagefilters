from PIL import Image, ImageFilter, ImageChops, ImageOps, ImageDraw, ImageFont
import numpy as np
import math
from medianDeNoise import medianDeNoise
from sharpen import sharpen

impath="/Users/juliuspark/Desktop/cat/a.jpg"
im=Image.open(impath)
w, h = im.size
#im=ImageOps.fit(im, [w//4,h//4], Image.NEAREST)
#w, h = im.size
imarray = np.asarray(im).copy().astype(np.uint8).reshape(h,w,3)
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
image = Image.fromarray(sharpen(imarray,w,h), 'RGB')
image.show()
