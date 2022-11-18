from fastapi import HTTPException, status


class GradeNotFound(HTTPException):
    def __init__(self, id: int = None):
        super().__init__(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Grade with id {id} not found" if id is not None else "Grade not found",
        )


class GradeAlreadyExists(HTTPException):
    def __init__(self, student_id: int, subject_id: int, semester: int):
        super().__init__(
            status_code=status.HTTP_409_CONFLICT,
            detail=f"Grade with student_id {student_id}, subject_id {subject_id} and semester {semester} already exists",
        )