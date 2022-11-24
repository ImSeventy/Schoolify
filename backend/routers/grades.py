from datetime import datetime
from fastapi import APIRouter, status, Depends
from lib.database.manager import DataBaseManager
from lib.exceptions.grades import DegreeTooHigh, GradeNotFound, GradeAlreadyExists, StudentHasNoSuchSubject, StudentNotFound, SubjectNotFound
from lib.checks.checks import grade_already_exists, student_exists, student_has_subject
from lib.date_manager.date_manager import DateManager
from lib.authentication.authentication import oauth2_scheme, get_user

from models.grades_models import GradeIn, GradeOut, GradeUpdate


grades = APIRouter(
    prefix="/grades",
    tags=["grades"],
)

@grades.get("/student", response_model=list[GradeOut], status_code=status.HTTP_200_OK)
async def get_student_grades(
    id: int,
    grade: int = None,
    semester: int = None,
    subject_id: int = None,
    token: str = Depends(oauth2_scheme)
    ):
    _ = await get_user("admin", "student", token=token)

    if not await student_exists(id):
        raise StudentNotFound(id)
    
    return await DataBaseManager().get_student_grades(
        student_id=id,
        grade=grade,
        semester=semester,
        subject_id=subject_id
    )

@grades.get("/this_year", response_model=list[GradeOut], status_code=status.HTTP_200_OK)
async def get_student_grades_this_year(
    id: int,
    this_semester: bool = False,
    semester: int = None,
    subject_id: int = None,
    token: str = Depends(oauth2_scheme)
    ):
    _ = await get_user("admin", "student", token=token)

    student = await DataBaseManager().get_student(id)
    if student is None:
        raise StudentNotFound(id)

    if this_semester:
        semester = DateManager().get_current_semester(datetime.utcnow()).value

    current_grade = DateManager().get_current_grade(student.entry_year)
    
    return await DataBaseManager().get_student_grades(
        student_id=id,
        grade=current_grade,
        semester=semester,
        subject_id=subject_id
    )

@grades.get("/{id}", response_model=GradeOut, status_code=status.HTTP_200_OK)
async def get_grade(id: int, token: str = Depends(oauth2_scheme)):
    _ = await get_user("admin", "student", token=token)

    grade = await DataBaseManager().get_grade_with_id(id)
    if grade is None:
        raise GradeNotFound(id)

    return grade

@grades.post("/", response_model=GradeOut, status_code=status.HTTP_201_CREATED)
async def create_grade(grade: GradeIn, token: str = Depends(oauth2_scheme)):
    _ = await get_user("admin", token=token)

    if await grade_already_exists(
        student_id=grade.student_id,
        subject_id=grade.subject_id,
        semester=grade.semester
    ):
        raise GradeAlreadyExists(grade.student_id, grade.subject_id, grade.semester)

    if not await student_has_subject(grade.student_id, grade.subject_id):
        raise StudentHasNoSuchSubject(grade.student_id, grade.subject_id)

    subject = await DataBaseManager().get_subject(grade.subject_id)
    if subject is None:
        raise SubjectNotFound(grade.subject_id)

    if grade.grade > subject.full_degree:
        raise DegreeTooHigh(grade.grade, subject.full_degree)

    id =  await DataBaseManager().create_grade(grade)
    return {**grade.dict(), "id": id, "subject_name": subject.name, "full_degree": subject.full_degree}


@grades.patch("/{id}", status_code=status.HTTP_204_NO_CONTENT)
async def update_grade(id: int, grade: GradeUpdate, token: str = Depends(oauth2_scheme)):
    _ = await get_user("admin", token=token)

    if not await grade_already_exists(id=id):
        raise GradeNotFound(id)

    await DataBaseManager().update_grade(id, **grade.dict())


@grades.delete("/", status_code=status.HTTP_204_NO_CONTENT)
async def delete_grade(student_id: int, subject_id: int, semester: int, token: str = Depends(oauth2_scheme)):
    _ = await get_user("admin", token=token)

    if not await grade_already_exists(
        student_id=student_id,
        subject_id=subject_id,
        semester=semester
    ):
        raise GradeNotFound()

    await DataBaseManager().delete_grade(student_id, subject_id, semester)


@grades.delete("/{id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_grade(id: int, token: str = Depends(oauth2_scheme)):
    _ = await get_user("admin", token=token)

    if not await grade_already_exists(id=id):
        raise GradeNotFound(id)

    await DataBaseManager().delete_grade_with_id(id)

