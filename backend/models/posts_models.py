from pydantic import BaseModel
from typing import Optional

class Post(BaseModel):
    id : int
    content : str
    image_url : Optional[str] = None
    by : int


class PostIn(BaseModel):
    content : str
    image_url : Optional[str] = None
    by : int = None


class PostOut(BaseModel):
    id : int
    content : str
    image_url : Optional[str] = None
    by : int
    like_count : int = 0


class PostEdit(BaseModel):
    content : str
    image_url : Optional[str] = None