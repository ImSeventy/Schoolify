from pydantic import BaseModel

class AbsenceIn(BaseModel):
    student_id: int
    date: str

class AbsenceOut(BaseModel):
    student_id: int

class AbsenceEdit(BaseModel):
    student_id: int
    date: str