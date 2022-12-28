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


class WrongEmailOrPassword(HTTPException):
    def __init__(self):
        super().__init__(
            status.HTTP_400_BAD_REQUEST,
            "Wrong email or password"
        )


class InvalidImageForamt(HTTPException):
    def __init__(self):
        super().__init__(
            status.HTTP_400_BAD_REQUEST,
            "Invalid image format"
        )


class WrongPassword(HTTPException):
    def __init__(self):
        super().__init__(
            status.HTTP_400_BAD_REQUEST,
            "Wrong password"
        )


class ImageNotFound(HTTPException):
    def __init__(self):
        super().__init__(
            status.HTTP_404_NOT_FOUND,
            "Image isn't found"
        )