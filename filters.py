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
    for i in range(1,h-2):
        for n in range(1,w-2):
            #neighborsmatrix=np.asarray([imarray[i - 1::i + 1, n - 1].reshape(1,2,3)[0][:],imarray[i - 1:i + 1, n].reshape(1,2,3)[0][:],imarray[i - 1:i + 1,n + 1].reshape(1,2,3)[0][:][:]]).reshape(1,6,3)
            #print(neighborsmatrix[0][:][:])
            neighborsmatrix=np.asarray([imarray[i-1,n-1,:],imarray[i+1,n-1,:],imarray[i,n-1,:],imarray[i+1,n,:],imarray[i-1,n,:],imarray[i-1,n+1,:],imarray[i,n+1,:],imarray[i+1,n+1,:],]).reshape(1,8,3)
            imarray[i,n]=np.median(neighborsmatrix[0][:][:], axis=0)
    return imarray
image = Image.fromarray(medianDeNoise(imarray,w,h), 'RGB')
image.show()
