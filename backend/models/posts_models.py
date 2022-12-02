from pydantic import BaseModel
from typing import Optional

class Post(BaseModel):
    post_id : int
    content : str
    image_url : Optional[str] = None
    by : int


class PostIn(BaseModel):
    content : str
    image_url : Optional[str] = None
    by : int


class PostOut(BaseModel):
    post_id : int
    content : str
    image_url : Optional[str] = None
    by : int


class PostEdit(BaseModel):
    content : str
    image_url : Optional[str] = None