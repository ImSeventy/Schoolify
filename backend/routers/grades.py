from fastapi import APIRouter, status
from lib.database.manager import DataBaseManager
from lib.exceptions.grades import GradeNotFound, GradeAlreadyExists
from lib.checks.checks import grade_already_exists

from models.grades_models import GradeOut, GradeUpdate


grades = APIRouter(
    prefix="/grades",
    tags=["grades"],
)


@grades.get("/{id}", response_model=GradeOut, status_code=status.HTTP_200_OK)
async def get_grade(id: int):
    grade = await DataBaseManager().get_grade_with_id(id)
    if grade is None:
        raise GradeNotFound(id)

    return grade


@grades.post("/", response_model=GradeOut, status_code=status.HTTP_201_CREATED)
async def create_grade(grade: GradeOut):
    if await grade_already_exists(
        student_id=grade.student_id,
        subject_id=grade.subject_id,
        semester=grade.semester
    ):
        raise GradeAlreadyExists(grade.student_id, grade.subject_id, grade.semester)

    id =  await DataBaseManager().create_grade(grade)
    return {**grade.dict(), "id": id}


@grades.patch("/{id}", status_code=status.HTTP_204_NO_CONTENT)
async def update_grade(id: int, grade: GradeUpdate):
    if not await grade_already_exists(id=id):
        raise GradeNotFound(id)

    await DataBaseManager().update_grade(id, **grade)


@grades.delete("/", status_code=status.HTTP_204_NO_CONTENT)
async def delete_grade(student_id: int, subject_id: int, semester: int):
    if not await grade_already_exists(
        student_id=student_id,
        subject_id=subject_id,
        semester=semester
    ):
        raise GradeNotFound()

    await DataBaseManager().delete_grade(student_id, subject_id, semester)


@grades.delete("/{id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_grade(id: int):
    if not await grade_already_exists(id=id):
        raise GradeNotFound(id)

    await DataBaseManager().delete_grade_with_id(id)

