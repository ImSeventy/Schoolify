from fastapi import APIRouter, status
from sqlite3 import IntegrityError
from lib.authentication.authentication import Authentication
from lib.checks.checks import student_exists
from lib.database.manager import DataBaseManager
from lib.exceptions.students import MajorDoesnotExist, StudentNotFound, WrongPassword

from models.students_models import StudentEdit, StudentIn, StudentOut, StudentResetPassword


students = APIRouter(
    prefix="/students",
    tags=["students"]
)


@students.get("/{id}", response_model=StudentOut, status_code=status.HTTP_200_OK)
async def get_student(id: int):
    student = await DataBaseManager().get_student(id)
    if student is None:
        raise StudentNotFound()

    return student


@students.get("/major/{id}", response_model=list[StudentOut], status_code=status.HTTP_200_OK)
async def get_major_students(id: int):
    return await DataBaseManager().get_major_students(id)


@students.post("/", response_model=StudentOut, status_code=status.HTTP_201_CREATED)
async def create_student(student: StudentIn):
    major = await DataBaseManager().get_major(student.major_id)
    if major is None:
        raise MajorDoesnotExist()

    try:
        id = await DataBaseManager().create_studnet(student)
    except IntegrityError:
        raise MajorDoesnotExist()


    return {**student.dict(), "id": id, "major_name": major.name}


@students.put("/{id}", response_model=StudentOut)
async def update_student(id: int, new_student: StudentEdit):
    if not await student_exists(id):
        raise StudentNotFound()
    await DataBaseManager().update_student(id, **new_student.dict())
    return {**new_student.dict(), "id": id}


@students.patch("/reset_password/{id}", status_code=status.HTTP_204_NO_CONTENT)
async def reset_password(id: int, passwords_scheme: StudentResetPassword):
    student = await DataBaseManager().get_student(id)
    if student is None:
        raise StudentNotFound()

    if not Authentication().verify_password(passwords_scheme.old_password, student.password):
        raise WrongPassword()

    await DataBaseManager().update_student(id, password=passwords_scheme.new_password)

