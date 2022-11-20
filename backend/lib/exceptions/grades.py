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


class StudentNotFound(HTTPException):
    def __init__(self, id: int):
        super().__init__(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Student with id {id} not found",
        )


class SubjectNotFound(HTTPException):
    def __init__(self, id: int):
        super().__init__(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Subject with id {id} not found",
        )


class DegreeTooHigh(HTTPException):
    def __init__(self, grade: float, full_degree: float):
        super().__init__(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=f"Grade {grade} is higher than full degree {full_degree}",
        )


class StudentHasNoSuchSubject(HTTPException):
    def __init__(self, student_id: int, subject_id: int):
        super().__init__(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=f"Student with id {student_id} has no subject with id {subject_id}",
        )