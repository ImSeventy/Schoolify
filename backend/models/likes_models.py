from pydantic import BaseModel

class Like(BaseModel):
    id : int
    by : int
    post_id : int

class LikeOut(BaseModel):
    id : int
    by : int
    post_id : int