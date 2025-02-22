'''
Allows the API to be used via command line arguments,
where we expect a single command line argument, a local image.
'''

import sys

from inference_sdk import InferenceHTTPClient

n = len(sys.argv)

if n != 2:
    raise Exception("Invalid number of arguments")

CLIENT = InferenceHTTPClient(
    api_url="https://detect.roboflow.com",
    api_key="22tzVfDkBC7oIorFHU2Y"
)

def scan_image(image_path : str):
    try:
        result = CLIENT.infer(image_path, model_id="drunk-or-sober-iwnwj/1")

        print(result)
    except Exception as e:
        print(e)

# python detect_drunk [IMAGE_FILE_PATH]