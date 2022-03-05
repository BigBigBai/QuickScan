import io
import os
from google.cloud import vision

def imagedetect():
    credential_path = "/solar-icon-319404-c5165d8e60d1.json"
    os.environ['GOOGLE_APPLICATION_CREDENTIALS'] = os.getcwd() + credential_path

    # The name of the image file to annotate
    os.chdir('./output_models')
    # Loads the image into memory
    with io.open('thumbnail.png', 'rb') as image_file:
        content = image_file.read()

    image = vision.Image(content=content)
    client = vision.ImageAnnotatorClient()

    # Performs label detection on the image file
    response = client.label_detection(image=image)
    labels = response.label_annotations

    print('Labels:')
    for label in labels:
        print(label.description)
    os.chdir('../')

# uncomment for testing:
# imagedetect()