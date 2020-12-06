import numpy as np
import matplotlib.pyplot as plt


data_path = "./data/"
file_num = 7
with open("test{}.txt".format(file_num), "r") as fp:

    img =fp.readlines()


img = [i.split() for i in img]
for i,img_row in enumerate(img):
    img[i] = [int( num, 16) for num in img_row]

#print(img)
img = np.array(img,dtype= np.float32)
img = np.reshape(img,(6,124,124))
#print(img)
for i, data in enumerate(img):
    plt.imshow(data,cmap='gray')
    plt.savefig(data_path+"{}_{}.png".format(file_num,i), bbox_inches='tight')

    # 그냥 , shobel col ,shobel row, highpass  ,shobell full, smooth
    plt.show()