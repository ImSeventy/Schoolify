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
    given_by: int
    grade_year: int
    semester: int


class CertificationOut(BaseModel):
    id: int
    student_id: int
    content: str
    image_url: Optional[str] = None
    date: float
    given_by: int
    given_by_name: str
    given_by_image_url: Optional[str] = None
    grade_year: int
    semester: int

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
        self.image_url: Optional[str] = None
        self.given_by: Optional[int] = None
        self.grade_year: Optional[int] = None
        self.semester: Optional[int] = None
        self.date = datetime.utcnow()

    def as_dict(self) -> dict:
        return {
            "student_id": self.student_id,
            "content": self.content,
            "image_url": self.image_url,
            "date": self.date,
            "given_by": self.given_by,
            "grade_year": self.grade_year,
            "semester": self.semester,
        }


class CertificationEditFormModel:
    def __init__(
        self,
        content: str = Form(),
        image: UploadFile = None,
    ):
        self.content = content
        self.image = image
        self.image_url = None

    def as_dict(self) -> dict:
        return {
            "content": self.content,
            "image_url": self.image_url,
        }