from fastapi import HTTPException, status


class EmailIsAlreadyUsed(HTTPException):
    def __init__(self):
        super().__init__(
            status.HTTP_409_CONFLICT,
            "email is already used by another admin"
        )


class AdminNotFound(HTTPException):
    def __init__(self):
        super().__init__(
            status.HTTP_404_NOT_FOUND,
            "Admin isn't found"
        )


class WrongPassowrd(HTTPException):
    def __init__(self):
        super().__init__(
            status.HTTP_400_BAD_REQUEST,
            "Wrong password"
        )