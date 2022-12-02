from pydantic import BaseModel

class Like(BaseModel):
    like_id : int
    by : int
    post_id : int


class LikeIn(BaseModel):
    by : int = None
    post_id : int


class LikeOut(BaseModel):
    like_id : int
    by : int
    post_id : int