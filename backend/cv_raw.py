from inference_sdk import InferenceHTTPClient

CLIENT = InferenceHTTPClient(
    api_url="https://detect.roboflow.com",
    api_key="22tzVfDkBC7oIorFHU2Y"
)

def scan_image(image_path : str) -> dict:
    try:
        result = CLIENT.infer('test_image.jpg', model_id="drunk-or-sober-iwnwj/1")

        print(result)

        return result
    except Exception as e:
        print(e)

        return {}
