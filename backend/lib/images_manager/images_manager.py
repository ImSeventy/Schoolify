import os
from uuid import uuid4
from fastapi import UploadFile
from lib.singleton_handler import Singleton


class ImagesManager(metaclass=Singleton):
    def __init__(self, images_path: str, ip_address: str):
        self.images_path = images_path
        self.ip_address = ip_address

    def is_valid_image(self, image: UploadFile) -> bool:
        return image.content_type.startswith("image/")

    def image_exists(self, image_name: str, sub_path: str) -> bool:
        image_path = f"{self.images_path}/{sub_path}/{image_name}"
        return os.path.exists(image_path)

    def save_image(self, image: UploadFile, sub_path: str) -> str:
        image_extension = image.filename.split(".")[-1]
        image_name = f"{uuid4()}.{image_extension}"
        image_path = f"{self.images_path}/{sub_path}/{image_name}"
        with open(image_path, "wb") as buffer:
            buffer.write(image.file.read())

        return f"{self.ip_address}/{sub_path}/image/{image_name}"

    def delete_image(self, image_path: str) -> None:
        import os
        os.remove(image_path)

    def get_image_path(self, image_name: str, sub_path: str) -> str:
        return f"{self.images_path}/{sub_path}/{image_name}"