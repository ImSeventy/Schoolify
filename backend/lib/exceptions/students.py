from fastapi import HTTPException, status


class StudentNotFound(HTTPException):
    def __init__(self):
        super().__init__(
            status.HTTP_404_NOT_FOUND,
            "Student not found"
        )


class EmailAlreadyExists(HTTPException):
    def __init__(self):
        super().__init__(
            status.HTTP_409_CONFLICT,
            "This email is already taken by another student"
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