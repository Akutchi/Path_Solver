from PIL import Image
import sys

arg_list = sys.argv

Dest = arg_list [1]
Image_Name = arg_list[2]
W = int(arg_list[3])
H = int(arg_list[4])

img = Image.new('RGBA', (W, H), (0, 0, 0, 0))
img.save(Dest+Image_Name, 'PNG')


