from pydantic import BaseModel


class Warning(BaseModel):
    id : int
    content : str
    by : str


class WarningIn(BaseModel):
    content : str
    by : str


class WarningOut(BaseModel):
    id : int
    content : str
    by : str


class WarningEdit(BaseModel):
    content : str