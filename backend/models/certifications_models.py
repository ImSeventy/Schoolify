from datetime import datetime, date, timezone
from typing import Optional

from fastapi import Form, UploadFile
from pydantic import BaseModel, validator

class Certifiaction(BaseModel):
    id: int
    student_id: int
    content: str
    image_url: Optional[str] = None
    date: date


class CertificationOut(BaseModel):
    id: int
    student_id: int
    content: str
    image_url: Optional[str] = None
    date: float

    @validator("date", pre=True)
    def date_to_timestamp(cls, date: date | str) -> float:
        if isinstance(date, str):
            date = datetime.strptime(date, "%Y-%m-%d")
        return datetime(date.year, date.month, date.day, tzinfo=timezone.utc).timestamp()


class CertificationFormModel:
    def __init__(
        self,
        student_id: int = Form(),
        content: str = Form(),
        image: UploadFile = None,
    ):
        self.student_id = student_id
        self.content = content
        self.image = image
        self.date = datetime.utcnow()