from typing import Optional
from pydantic import BaseModel, EmailStr, validator, root_validator

from lib.authentication.authentication import Authentication
from lib.database.manager import DataBaseManager


class Student(BaseModel):
    id: int
    rf_id: int
    name: str
    email: EmailStr
    password: str
    entry_year: int
    major_id: int


class StudentIn(BaseModel):
    rf_id: int
    name: str
    email: EmailStr
    password: str
    entry_year: int
    major_id: int

    @validator("password", pre=True)
    def password_validator(cls, password: str) -> str:
        if len(password) <= 6:
            raise ValueError("Password must be longer than three charactars")

        return Authentication().hash_password(password)


class StudentOut(BaseModel):
    id: int
    rf_id: int
    name: str
    email: EmailStr
    entry_year: int
    major_id: int
    major_name: Optional[str] = None


class StudentEdit(BaseModel):
    rf_id: int
    name: str
    email: EmailStr


class StudentResetPassword(BaseModel):
    old_password: str
    new_password: str

    @validator("new_password", pre=True)
    def new_password_validator(cls, password: str) -> str:
        if len(password) <= 6:
            raise ValueError("Passowrd must be longer than 6 charactars")
        
        return Authentication().hash_password(password)