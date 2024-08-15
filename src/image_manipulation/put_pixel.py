from PIL import Image
import sys

arg_list = sys.argv

Dest = arg_list [1]
Image_Name = arg_list[2]
X = int(arg_list[3])
Y = int(arg_list[4])
colors_str = arg_list[5].split(",")
color = (int(colors_str[0]), int(colors_str[1]), int(colors_str[2]), 1)

im = Image.open(Dest+Image_Name).convert('RGB')
pix = im.load()
pix[X, Y] = color
im.save(Dest+Image_Name, 'PNG')

