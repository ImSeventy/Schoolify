from fastapi import HTTPException, status


class StudentNotFound(HTTPException):
    def __init__(self):
        super().__init__(
            status.HTTP_404_NOT_FOUND,
            "Student not found"
        )


class StudentIsAlreadyAbsentToday(HTTPException):
    def __init__(self):
        super().__init__(
            status.HTTP_409_CONFLICT,
            "Student is already absent today"
        )


class AbsenceNotFound(HTTPException):
    def __init__(self):
        super().__init__(
            status.HTTP_404_NOT_FOUND,
            "Absence not found"
        )