from pydantic import BaseModel, validator


class Subject(BaseModel):
    id: int
    name: str
    full_degree: int
    major_id: int
    major_name: str
    grade: int


class SubjectIn(BaseModel):
    name: str
    full_degree: int
    major_id: int
    grade: int

    @validator("name", pre=True)
    def name_validator(cls, name: str) -> str:
        return name.lower()


class SubjectOut(BaseModel):
    id: int
    name: str
    full_degree: int
    major_id: int
    major_name: str
    grade: int


class SubjectEdit(BaseModel):
    name: str
    full_degree: int

    @validator("name", pre=True)
    def name_validator(cls, name: str) -> str:
        return name.lower()