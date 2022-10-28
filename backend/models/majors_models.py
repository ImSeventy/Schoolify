from pydantic import BaseModel

class MajorIn(BaseModel):
    name: str

class MajorEdit(BaseModel):
    name: str

class MajorOut(BaseModel):
    id: int
    name: str