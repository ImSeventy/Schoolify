from pydantic import BaseModel


class Warning(BaseModel):
    id : int
    content : str
    student_id : int


class WarningIn(BaseModel):
    content : str
    student_id : int


class WarningOut(BaseModel):
    id : int
    content : str
    student_id : int


class WarningEdit(BaseModel):
    content : str