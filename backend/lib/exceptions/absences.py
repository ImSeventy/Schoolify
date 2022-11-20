from fastapi import HTTPException, status


class StudentNotFound(HTTPException):
    def __init__(self):
        super().__init__(
            status.HTTP_404_NOT_FOUND,
            "Student not found"
        )


class StudentIsNotAbsentToday(HTTPException):
    def __init__(self):
        super().__init__(
            status.HTTP_404_NOT_FOUND,
            "Student is not absent today"
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


class InvalidDateFormat(HTTPException):
    def __init__(self):
        super().__init__(
            status.HTTP_400_BAD_REQUEST,
            "Invalid date format"
        )


class StudentIsNotAbsentAtDate(HTTPException):
    def __init__(self, date: str):
        super().__init__(
            status.HTTP_404_NOT_FOUND,
            F"Student is not absent at {date}"
        )