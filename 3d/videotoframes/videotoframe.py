import cv2
from blurdetect import isblurry
from reduceframes import removeSimilarFramesRMS, removeSimilarFramesSIFT
import shutil
import os

output_directory = './frames'

if os.path.exists(output_directory):
  shutil.rmtree(output_directory)

os.makedirs(output_directory)

vidcap = cv2.VideoCapture('./input_videos/input.MOV')
success,image = vidcap.read()
count = 0

while success:
  success,image = vidcap.read()

  if image is None:
    continue

  pictureblurred, fm = isblurry(image)
  if pictureblurred == False:
    #cv2.putText(image, "{}: {:.2f}".format('Blur', fm), (10, 30),
		  #cv2.FONT_HERSHEY_SIMPLEX, 0.8, (0, 0, 255), 3)
    cv2.imwrite(output_directory + '/'+ "frame%d.jpg" % count, image)     # save frame as JPG file      
    count += 1
  else:
    print ("blurry frame was deleted")


removeSimilarFramesRMS()
removeSimilarFramesSIFT()
print("NUMBER OF FRAMES LEFT", len(os.listdir(output_directory)))
print('Completed video to frame processing, generating model now...')

os.system('./HelloPhotogrammetry {} ./output_models/result.usdz -d medium '.format(output_directory))

print('Completed Model')
