from fastapi import HTTPException, status

class WrongPassowrdOrEmail(HTTPException):
    def __init__(self):
        super().__init__(
            status.HTTP_400_BAD_REQUEST,
            "Wrong password or email"
        )