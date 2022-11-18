from pydantic import BaseModel

class Grade(BaseModel):
    id: int
    student_id: int
    subject_id: int
    grade: float
    semester: int


class GradeIn(BaseModel):
    student_id: int
    subject_id: int
    grade: float
    semester: int


class GradeOut(BaseModel):
    id: int
    student_id: int
    subject_id: int
    grade: float
    semester: int


class GradeUpdate(BaseModel):
    grade: float