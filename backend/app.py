from flask import Flask

from cv_raw import scan_image

import base64
# scan_image('test_image.jpg')

app = Flask(__name__)

@app.route('/')
def home():

    # Generate the data to test the endpoint
    # print(test_image_scanning())
    
    # scan_image(test_image_scanning())

    return 'Hello World!'

# The api endpoint allowing for a user's pictures
# to be scanned and their level of intoxication to
# be determined
@app.route('/scan/<image_data>')
def scan(image_data):
    try:
        print('Now scanning image')

        scan_image(image_data)

        print('Image successfully scanned')
    except Exception as e:
        print(f'An error occured {e}')

    return 'Image Scanning Underway'

# Returns test data for the end point
def test_image_scanning():
    with open('test_image.jpg', 'rb') as image_file:
        encoded_string = base64.b64encode(image_file.read())
    return encoded_string

if __name__ == '__main__':
    app.run()