from fastapi import APIRouter, status, Depends

from lib.date_manager.date_manager import DateManager
from lib.authentication.authentication import oauth2_scheme, get_user
from lib.checks.checks import student_exists, student_is_absent_at_date, student_is_absent_today, absence_exists
from lib.exceptions.absences import InvalidDateFormat, StudentIsNotAbsentAtDate, StudentIsNotAbsentToday, StudentNotFound, StudentIsAlreadyAbsentToday, AbsenceNotFound
from lib.database.manager import DataBaseManager
from models.absences_models import AbsenceIn, AbsenceOut


absence = APIRouter(
    prefix="/absence",
    tags=["absence"]
)


@absence.post("/", response_model=AbsenceOut, status_code=status.HTTP_201_CREATED)
async def add_absence(absence: AbsenceIn, token: str = Depends(oauth2_scheme)):
    _ = await get_user("admin", token=token)

    student = await DataBaseManager().get_student(absence.student_id)
    if student is None:
        raise StudentNotFound()

    if await student_is_absent_today(absence.student_id):
        raise StudentIsAlreadyAbsentToday()

    absence.setup_grade_and_semester(student)

    id = await DataBaseManager().set_student_as_absent_today(absence)
    return {**absence.dict(), "id": id}

@absence.delete("/{id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_absence_with_id(id: int, token: str = Depends(oauth2_scheme)):
    _ = await get_user("admin", token=token)

    if not await absence_exists(id):
        raise AbsenceNotFound()

    await DataBaseManager().delete_absence_with_id(id)

@absence.delete("/today/{student_id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_student_absence_today(student_id: int, token: str = Depends(oauth2_scheme)):
    _ = await get_user("admin", token=token)

    if not await student_exists(student_id):
        raise StudentNotFound()
    
    if not await student_is_absent_today(student_id):
        raise AbsenceNotFound()

    await DataBaseManager().delete_student_today_absence(student_id)

@absence.delete("/", status_code=status.HTTP_204_NO_CONTENT)
async def delete_student_absence_date(student_id: int, date: str, token: str = Depends(oauth2_scheme)):
    _ = await get_user("admin", token=token)

    if not DateManager().is_proper_format(date):
        raise InvalidDateFormat()

    if not await student_exists(student_id):
        raise StudentNotFound()
    
    if not await student_is_absent_at_date(student_id, date):
        raise StudentIsNotAbsentAtDate(date)

    await DataBaseManager().delete_student_absence_at_date(student_id, date)

@absence.get("/student/{id}", response_model=list[AbsenceOut], status_code=status.HTTP_200_OK)
async def get_student_absences(id: int, token: str = Depends(oauth2_scheme)):
    _ = await get_user("admin", "student", token=token)

    if not await student_exists(id):
        raise StudentNotFound()
    
    return await DataBaseManager().get_student_absences(id)

@absence.get("/student", response_model=list[AbsenceOut], status_code=status.HTTP_200_OK)
async def get_student_grade_absences(
    student_id: int,
    grade: int,
    semester: int = None,
    token: str = Depends(oauth2_scheme)
    ):
    _ = await get_user("admin", "student", token=token)

    if not await student_exists(student_id):
        raise StudentNotFound()
    
    return await DataBaseManager().get_student_grade_absences(student_id, grade, semester)