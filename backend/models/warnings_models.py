from typing import Optional
from datetime import datetime, date, timezone
from pydantic import BaseModel, validator


class Warning(BaseModel):
    id: int
    content: str
    student_id: int
    date: date
    grade_year: int
    semester: int


class WarningIn(BaseModel):
    content: str
    student_id: int
    date: datetime = None
    grade_year: Optional[int] = None
    semester: Optional[int] = None

    def __init__(self, **data):
        data["date"] = datetime.utcnow()
        super().__init__(**data)

class WarningOut(BaseModel):
    id: int
    content: str
    student_id: int
    date: float
    grade_year: int
    semester: int

    @validator("date", pre=True)
    def date_to_timestamp(cls, date: date | str) -> float:
        if isinstance(date, str):
            date = datetime.strptime(date, "%Y-%m-%d")
        return datetime(date.year, date.month, date.day, tzinfo=timezone.utc).timestamp()


class WarningEdit(BaseModel):
    content: str