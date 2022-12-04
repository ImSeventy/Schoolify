from fastapi import Form, UploadFile
from pydantic import BaseModel
from typing import Optional


class Post(BaseModel):
    id: int
    content: str
    image_url: Optional[str] = None
    by: int

class PostOut(BaseModel):
    id: int
    content: str
    image_url: Optional[str] = None
    by: int
    like_count: int = 0


class PostEdit(BaseModel):
    content: str
    image_url: Optional[str] = None


class PostFormModel:
    def __init__(
        self,
        image: UploadFile = None,
        content: str = Form(),
        by: int = Form(None),
    ):
        self.content = content
        self.image = image
        self.image_url: str = None
        self.by = by

    def as_dict(self) -> dict:
        return {
            "content": self.content,
            "by": self.by,
            "image_url": self.image_url,
        }
