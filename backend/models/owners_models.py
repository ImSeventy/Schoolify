from pydantic import BaseModel, EmailStr

class Owner(BaseModel):
    id: int
    name: str
    email: EmailStr