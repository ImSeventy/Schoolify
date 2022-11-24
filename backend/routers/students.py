from fastapi import APIRouter, status, Depends
from fastapi.security import OAuth2PasswordRequestForm
from sqlite3 import IntegrityError
from lib.authentication.authentication import Authentication, get_user, oauth2_scheme
from lib.checks.checks import student_exists
from lib.database.manager import DataBaseManager
from lib.exceptions.auth import WrongEmailOrPassword
from lib.exceptions.students import EmailAlreadyExists, MajorDoesnotExist, StudentNotFound, WrongPassword

from models.students_models import Student, StudentEdit, StudentIn, StudentOut, StudentPersonalUpdate, StudentResetPassword


students = APIRouter(
    prefix="/students",
    tags=["students"]
)


# @students.get("/class", response_model=list[StudentOut], status_code=status.HTTP_200_OK)
# async def get_class_students(major_id: int, grade: int):
#     return await DataBaseManager().query_class_students(major_id, grade)


@students.get("/{id}", response_model=StudentOut, status_code=status.HTTP_200_OK)
async def get_student(id: int, token: str = Depends(oauth2_scheme)):
    _ = await get_user("admin_or_student", token)
    student = await DataBaseManager().get_student(id)
    if student is None:
        raise StudentNotFound()

    return student

@students.get("/major/{id}", response_model=list[StudentOut], status_code=status.HTTP_200_OK)
async def get_major_students(id: int, token: str = Depends(oauth2_scheme)):
    _ = await get_user("admin_or_student", token)
    return await DataBaseManager().get_major_students(id)

@students.post("/", response_model=StudentOut, status_code=status.HTTP_201_CREATED)
async def create_student(student: StudentIn, token: str = Depends(oauth2_scheme)):
    _ = await get_user("admin", token)

    major = await DataBaseManager().get_major(student.major_id)
    if major is None:
        raise MajorDoesnotExist()

    try:
        id = await DataBaseManager().create_studnet(student)
    except IntegrityError:
        raise EmailAlreadyExists()


    return {**student.dict(), "id": id, "major_name": major.name}

@students.post("/login", status_code=status.HTTP_200_OK)
async def login_student(credintials: OAuth2PasswordRequestForm = Depends()):
    student = await DataBaseManager().get_student(credintials.username)
    if student is None:
        raise WrongEmailOrPassword()

    if not Authentication.verify_password(student.password, credintials.password):
        raise WrongEmailOrPassword()

    data = {
        "id": student.id,
        "role": "student"
    }

    return {
        "access_token": Authentication().create_access_token(data),
        "refresh_token": Authentication().create_refresh_token(data),
        "token_type": "bearer"
        }

@students.post("/refresh", status_code=status.HTTP_200_OK)
async def refresh_student(token: str = Depends(oauth2_scheme)):
    access_token, refresh_token = Authentication().refresh_access_token(token)
    return {
        "access_token": access_token,
        "refresh_token": refresh_token,
        "token_type": "bearer"
        }

@students.get("/me", response_model=StudentOut, status_code=status.HTTP_200_OK)
async def get_student_me(token: str = Depends(oauth2_scheme)):
    student = await get_user("student", token)
    return student

@students.put("/", status_code=status.HTTP_204_NO_CONTENT)
async def edit_student(new_student: StudentPersonalUpdate, token: str = Depends(oauth2_scheme)):
    student = await get_user("student", token)
    await DataBaseManager().update_student(student.id, **new_student)

@students.put("/{id}", status_code=status.HTTP_204_NO_CONTENT)
async def update_student(id: int, new_student: StudentEdit, token: str = Depends(oauth2_scheme)):
    _ = await get_user("admin", token)

    if not await student_exists(id):
        raise StudentNotFound()

    await DataBaseManager().update_student(id, **new_student.dict())

@students.patch("/reset_password", status_code=status.HTTP_204_NO_CONTENT)
async def reset_password(passwords_scheme: StudentResetPassword, token: str = Depends(oauth2_scheme)):
    student = await get_user("student", token)
    if not Authentication().verify_password(passwords_scheme.old_password, student.password):
        raise WrongPassword()

    await DataBaseManager().update_student(student.id, password=passwords_scheme.new_password)

@students.delete("/", status_code=status.HTTP_204_NO_CONTENT)
async def delete_student(token: str = Depends(oauth2_scheme)):
    student = await get_user("student", token)
    await DataBaseManager().delete_student(student.id)

@students.delete("/{id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_student_by_admin(id: int, token: str = Depends(oauth2_scheme)):
    _ = await get_user("admin", token)

    if not await student_exists(id):
        raise StudentNotFound()

    await DataBaseManager().delete_student(id)

