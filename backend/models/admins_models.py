from typing import Optional
from pydantic import BaseModel, validator, EmailStr

from constants.enums import Roles
from lib.authentication import Authentication


class AdminIn(BaseModel):
    name: str
    role: str
    email: EmailStr
    password: str

    @validator("role", pre=True)
    def role_validator(cls, role: str) -> str:
        role = role.lower()
        if not Roles.exists(role):
            raise ValueError(f"{role} isn't in the supported roles")

        return role

    @validator("password", pre=True)
    def password_validator(cls, password: str) -> str:
        if len(password) <= 6:
            raise ValueError("Passowrd must be longer than 6 charactars")
        
        return Authentication().hash_password(password)


class AdminOut(BaseModel):
    id: str
    name: str
    role: str
    email: str
    image_url: Optional[str] = None
    class Config:
        orm_mode = True

class Admin(BaseModel):
    id: str
    name: str
    role: str
    email: str
    password: str
    image_url: Optional[str] = None

    class Config:
        orm_mode = True


class AdminEdit(BaseModel):
    name: str
    role: str
    email: str

    @validator("role", pre=True)
    def role_validator(cls, role: str) -> str:
        role = role.lower()
        if not Roles.exists(role):
            raise ValueError(f"{role} isn't in the supported roles")

        return role


class AdminResetPassword(BaseModel):
    old_password: str
    new_password: str

    @validator("new_password", pre=True)
    def new_password_validator(cls, password: str) -> str:
        if len(password) <= 6:
            raise ValueError("Passowrd must be longer than 6 charactars")
        
        return Authentication().hash_password(password)


