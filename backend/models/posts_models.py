from datetime import datetime
from fastapi import Form, UploadFile
from pydantic import BaseModel, validator
from typing import Optional


class Post(BaseModel):
    id: int
    content: str
    image_url: Optional[str] = None
    by: int
    date: datetime

class PostOut(BaseModel):
    id: int
    content: str
    image_url: Optional[str] = None
    by: int
    by_name: str
    by_image_url: Optional[str] = None
    like_count: int = 0
    date: float

    @validator("date", pre=True)
    def date_validator(cls, date: datetime | str) -> float:
        if isinstance(date, str):
            date = datetime.fromisoformat(date)
        return date.timestamp()


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
        self.date = datetime.utcnow()

    def as_dict(self) -> dict:
        return {
            "content": self.content,
            "by": self.by,
            "image_url": self.image_url,
            "date": self.date
        }
