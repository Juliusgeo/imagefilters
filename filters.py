from PIL import Image, ImageFilter, ImageChops, ImageOps, ImageDraw, ImageFont
import numpy as np
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
    for i in range(1,h-1):
        for n in range(1,w-1):
            hichannel=np.argmax(imarray[i,n])
            if(imarray[i,n][hichannel]+amt<255):
                imarray[i,n][hichannel]+=amt
            else:
                imarray[i,n][hichannel]=255
    return imarray
#image = Image.fromarray(medianDeNoise(imarray,w,h), 'RGB')
image = Image.fromarray(saturationIncrease(imarray,40,w,h), 'RGB')
image.show()
