from fastapi import HTTPException, status


class StudentNotFound(HTTPException):
    def __init__(self):
        super().__init__(
            status.HTTP_404_NOT_FOUND,
            "Student not found"
        )


class MajorDoesnotExist(HTTPException):
    def __init__(self):
        super().__init__(
            status.HTTP_400_BAD_REQUEST,
            "There is not major with that id"
        )


class WrongPassword(HTTPException):
    def __init__(self):
        super().__init__(
            status.HTTP_400_BAD_REQUEST,
            "Wrong Password"
        )