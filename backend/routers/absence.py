from datetime import datetime
from fastapi import APIRouter, status

from models.absences_models import AbsenceIn, AbsenceOut
from lib.checks.checks import student_exists, student_is_absent_today, absence_exists
from lib.exceptions.absences import StudentNotFound, StudentIsAlreadyAbsentToday, AbsenceNotFound, StudentHasNoAbsence
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

@absence.delete("/student/{id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_student_absence_today(student_id: int):
    student = await DataBaseManager().get_student(student_id)
    if student is None:
        raise StudentNotFound()
    
    elif not await student_is_absent_today(student_id):
        raise AbsenceNotFound()

    else:
        absence_id = await DataBaseManager().get_absence_id(student_id)

        await DataBaseManager().delete_absence_with_id(absence_id)

@absence.delete("/student/date/{id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_student_absence_date(student_id: int, date: str):
    student = await DataBaseManager().get_student(student_id)
    if student is None:
        raise StudentNotFound()
    
    absence_id = await DataBaseManager().get_absence_id_by_date(student_id, date)
    
    if not await absence_exists(absence_id) or absence_id == None:
        raise AbsenceNotFound()

    await DataBaseManager().delete_absence_with_id(absence_id)

@absence.get("/absences/{id}", response_model=list[AbsenceOut], status_code=status.HTTP_200_OK)
async def get_student_absences(id: int):
    student = await DataBaseManager().get_student(id)
    if student is None:
        raise StudentNotFound()
    
    absences =  await DataBaseManager().get_student_absences(id)
    if len(absences) == 0:
        raise StudentHasNoAbsence()
    else:
        return absences

@absence.get("/absences/grade/{id}", response_model=list[AbsenceOut], status_code=status.HTTP_200_OK)
async def get_student_grade_absences(id: int, grade: int, semester: int=None):
    student = await DataBaseManager().get_student(id)
    if student is None:
        raise StudentNotFound()
    
    return await DataBaseManager().get_student_grade_absences(id, grade, semester)