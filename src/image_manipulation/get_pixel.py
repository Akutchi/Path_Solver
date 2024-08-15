from PIL import Image
import sys

arg_list = sys.argv

Dest = arg_list [1]
Image_Name = arg_list[2]
X = int(arg_list[3])
Y = int(arg_list[4])

im = Image.open(Dest+Image_Name).convert('RGB')

with open(Dest+"res.txt", 'w') as outfile:
    r,g,b = im.getpixel((X,Y))
    outfile.write("("+str(r)+","+str(g)+","+str(b)+")")


