from datetime import datetime, date as dt
from pydantic import BaseModel, validator

from models.students_models import Student
from lib.date_manager.date_manager import DateManager

class AbsenceIn(BaseModel):
    student_id: int
    date: datetime = None
    grade: int = None
    semester: int = None

    def setup_grade_and_semester(self, student: Student):
        self.date = datetime.utcnow()
        self.grade = DateManager().get_current_grade(student.entry_year)
        self.semester = DateManager().get_current_semester(self.date).value


class Absence(BaseModel):
    id: int
    student_id: int
    date: datetime
    grade: int
    semester: int

class AbsenceOut(BaseModel):
    id: int
    student_id: int
    date: float
    grade: int
    semester: int

    @validator("date", pre=True)
    def date_validator(cls, date: dt) -> float:
        if isinstance(date, str):
            date = datetime.strptime(date, "%Y-%m-%d")
        return datetime(date.year, date.month, date.day).timestamp()