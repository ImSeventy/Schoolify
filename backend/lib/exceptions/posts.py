from fastapi import HTTPException, status

class PostNotFound(HTTPException):
    def __init__(self):
        super().__init__(
            status.HTTP_404_NOT_FOUND,
            "Post not found"
        )