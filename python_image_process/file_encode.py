import PIL.Image as pilimg
import numpy as np
img =np.array(pilimg.open( "./drive_line3_scaled.png").convert("L"),dtype = np.uint8)
img = list(img)
for i in img:
    print(i)
with open("drive_scaled_3.coe", "w") as fp:
    fp.write("memory_initialization_radix=10;\nmemory_initialization_vector=\n")
    for i in img:
        for j in i:
            fp.write(str(j)+" ")
        fp.write("\n")

    