from fastapi import APIRouter, status, Depends, UploadFile
from fastapi.security import OAuth2PasswordRequestForm
from fastapi.responses import FileResponse
from sqlite3 import IntegrityError
from constants.enums import ImagesSubPaths
from lib.authentication.authentication import Authentication, get_user, oauth2_scheme
from lib.checks.checks import student_exists
from lib.database.manager import DataBaseManager
from lib.exceptions.auth import WrongEmailOrPassword
from lib.exceptions.students import EmailAlreadyExists, ImageNotFound, InvalidImageFormat, MajorDoesnotExist, StudentNotFound, WrongPassword
from lib.images_manager.images_manager import ImagesManager

from models.students_models import StudentEdit, StudentIn, StudentOut, StudentPersonalUpdate, StudentResetPassword, StudentRfidOut


students = APIRouter(
    prefix="/students",
    tags=["students"]
)


# @students.get("/class", response_model=list[StudentOut], status_code=status.HTTP_200_OK)
# async def get_class_students(major_id: int, grade: int):
#     return await DataBaseManager().query_class_students(major_id, grade)

@students.get("/image/{image_name}")
async def get_student_image(image_name: str):
    if not ImagesManager().image_exists(image_name, ImagesSubPaths.students.value):
        raise ImageNotFound()

    image_path = ImagesManager().get_image_path(image_name, ImagesSubPaths.students.value)
    return FileResponse(image_path)

@students.get("/rfid/{rf_id}", response_model=StudentRfidOut, status_code=status.HTTP_200_OK)
async def get_student_by_rfid(rf_id: int):
    student = await DataBaseManager().get_student_by_rfid(rf_id)
    if student is None:
        raise StudentNotFound()

    return student

@students.get("/me", response_model=StudentOut, status_code=status.HTTP_200_OK)
async def get_student_me(token: str = Depends(oauth2_scheme)):
    student = await get_user("student", token=token)
    return student

@students.get("/{id}", response_model=StudentOut, status_code=status.HTTP_200_OK)
async def get_student(id: int, token: str = Depends(oauth2_scheme)):
    _ = await get_user("admin", "student", token=token)
    student = await DataBaseManager().get_student(id)
    if student is None:
        raise StudentNotFound()

    return student

@students.get("/major/{id}", response_model=list[StudentOut], status_code=status.HTTP_200_OK)
async def get_major_students(id: int, token: str = Depends(oauth2_scheme)):
    _ = await get_user("admin", "student", token=token)
    return await DataBaseManager().get_major_students(id)

@students.post("/", response_model=StudentOut, status_code=status.HTTP_201_CREATED)
async def create_student(student: StudentIn, token: str = Depends(oauth2_scheme)):
    _ = await get_user("admin", token=token)

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

    if not Authentication.verify_password(credintials.password, student.password):
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

@students.put("/", status_code=status.HTTP_204_NO_CONTENT)
async def edit_student(new_student: StudentPersonalUpdate, token: str = Depends(oauth2_scheme)):
    student = await get_user("student", token=token)
    await DataBaseManager().update_student(student.id, **new_student)

@students.put("/{id}", status_code=status.HTTP_204_NO_CONTENT)
async def update_student(id: int, new_student: StudentEdit, token: str = Depends(oauth2_scheme)):
    _ = await get_user("admin", token=token)

    if not await student_exists(id):
        raise StudentNotFound()

    await DataBaseManager().update_student(id, **new_student.dict())

@students.patch("/set_image", status_code=status.HTTP_204_NO_CONTENT)
async def set_student_image(image: UploadFile, token: str = Depends(oauth2_scheme)):
    student = await get_user("student", token=token)
    if not ImagesManager().is_valid_image(image):
        raise InvalidImageFormat()

    image_url = ImagesManager().save_image(image, ImagesSubPaths.students.value)

    await DataBaseManager().update_student(student.id, image_url=image_url)

@students.patch("/reset_password", status_code=status.HTTP_204_NO_CONTENT)
async def reset_password(passwords_scheme: StudentResetPassword, token: str = Depends(oauth2_scheme)):
    student = await get_user("student", token=token)
    if not Authentication().verify_password(passwords_scheme.old_password, student.password):
        raise WrongPassword()

    await DataBaseManager().update_student(student.id, password=passwords_scheme.new_password)

@students.delete("/", status_code=status.HTTP_204_NO_CONTENT)
async def delete_student(token: str = Depends(oauth2_scheme)):
    student = await get_user("student", token=token)
    await DataBaseManager().delete_student(student.id)

@students.delete("/{id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_student_by_admin(id: int, token: str = Depends(oauth2_scheme)):
    _ = await get_user("admin", token=token)

    if not await student_exists(id):
        raise StudentNotFound()

    await DataBaseManager().delete_student(id)

