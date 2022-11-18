from datetime import datetime
from fastapi import APIRouter, status

from models.absences_models import AbsenceIn, AbsenceOut
from lib.checks.checks import student_exists, student_is_absent_today, absence_exists
from lib.exceptions.absences import StudentNotFound, StudentIsAlreadyAbsentToday, AbsenceNotFound
from lib.database.manager import DataBaseManager


absence = APIRouter(
    prefix="/absence",
    tags=["absence"]
)


@absence.post("/", response_model=AbsenceOut, status_code=status.HTTP_201_CREATED)
async def add_absence(absence: AbsenceIn):
    student = await DataBaseManager().get_student(absence.student_id)
    if student is None:
        raise StudentNotFound()

    if await student_is_absent_today(absence.student_id):
        raise StudentIsAlreadyAbsentToday()

    absence.setup_grade_and_semester(student)

    id = await DataBaseManager().set_student_as_absent_today(absence)
    return {**absence.dict(), "id": id}

@absence.delete("/{id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_absence_with_id(id: int):
    if not await absence_exists(id):
        raise AbsenceNotFound()

    await DataBaseManager().delete_absence_with_id(id)
        


    

    