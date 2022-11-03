from re import S
from fastapi import HTTPException, status


class SubjectNotFound(HTTPException):
    def __init__(self):
        super().__init__(
            status.HTTP_404_NOT_FOUND,
            "Subject not found"
        )


class MajorNotFound(HTTPException):
    def __init__(self):
        super().__init__(
            status.HTTP_404_NOT_FOUND,
            "Major not found"
        )


class ClassAlreadyHasSubject(HTTPException):
    def __init__(self):
        super().__init__(
            status.HTTP_409_CONFLICT,
            "This class already has subject with that name"
        )