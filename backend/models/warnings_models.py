from pydantic import BaseModel


class Warning(BaseModel):
    id : int
    content : str
    by : int


class WarningIn(BaseModel):
    content : str
    by : int


class WarningOut(BaseModel):
    id : int
    content : str
    by : int


class WarningEdit(BaseModel):
    content : str