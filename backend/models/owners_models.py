from pydantic import BaseModel, EmailStr

class Owner(BaseModel):
    id: int
    name: str
    email: EmailStr

class OwnerOut(BaseModel):
    id: int
    name: str
    email: EmailStr
    class Config:
        orm_mode = True