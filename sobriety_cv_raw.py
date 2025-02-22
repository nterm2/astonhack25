from inference_sdk import InferenceHTTPClient

CLIENT = InferenceHTTPClient(
    api_url="https://detect.roboflow.com",
    api_key="22tzVfDkBC7oIorFHU2Y"
)

result = CLIENT.infer('test_image.jpg', model_id="drunk-or-sober-iwnwj/1")

print(result)