from fastapi import APIRouter, status, Depends, UploadFile
from fastapi.security import OAuth2PasswordRequestForm
from fastapi.responses import FileResponse
from sqlite3 import IntegrityError
from constants.enums import ImagesSubPaths
from lib.authentication.authentication import Authentication, oauth2_scheme, get_user
from lib.checks.checks import admin_exists
from lib.database.manager import DataBaseManager
from lib.exceptions.admins import AdminNotFound, EmailIsAlreadyUsed, ImageNotFound, InvalidImageForamt, WrongPassowrd
from lib.images_manager.images_manager import ImagesManager

from models.admins_models import AdminEdit, AdminIn, AdminOut, AdminResetPassword


admins = APIRouter(prefix="/admins", tags=["admins"])


@admins.post("/", response_model=AdminOut, status_code=status.HTTP_201_CREATED)
async def create_admin(admin: AdminIn, token: str = Depends(oauth2_scheme)):
    _ = await get_user("owner", token=token)

    try:
        id = await DataBaseManager().create_admin(admin)
    except IntegrityError:
        raise EmailIsAlreadyUsed()

    return {**admin.dict(), "id": id}

@admins.post("/login", status_code=status.HTTP_200_OK)
async def login_admin(credintials: OAuth2PasswordRequestForm = Depends()):
    admin = await DataBaseManager().get_admin(credintials.username)
    if admin is None:
        raise AdminNotFound()

    if not Authentication.verify_password(credintials.password, admin.password):
        raise WrongPassowrd()

    data = {
        "id": admin.id,
        "role": "admin",
    }

    return {
        "access_token": Authentication().create_access_token(data),
        "refresh_token": Authentication().create_refresh_token(data),
        "token_type": "bearer"
        }

@admins.post("/refresh", status_code=status.HTTP_200_OK)
async def refresh_admin(token: str = Depends(oauth2_scheme)):
    access_token, refresh_token = Authentication().refresh_access_token(token)
    return {
        "access_token": access_token,
        "refresh_token": refresh_token,
        "token_type": "bearer"
        }


@admins.get("/me", response_model=AdminOut, status_code=status.HTTP_200_OK)
async def get_admin(token: str = Depends(oauth2_scheme)):
    return await get_user("admin", token=token)


@admins.get("/image/{image_name}", status_code=status.HTTP_200_OK)
async def get_admin_image(image_name: str):
    if not ImagesManager().image_exists(image_name, ImagesSubPaths.admins.value):
        raise ImageNotFound()

    image_path =  ImagesManager().get_image_path(image_name, ImagesSubPaths.admins.value)
    return FileResponse(image_path)


@admins.get("/{id}", response_model=AdminOut, status_code=status.HTTP_200_OK)
async def get_admin(id: int, token: str = Depends(oauth2_scheme)):
    _ = await get_user("admin", "owner", token=token)

    admin = await DataBaseManager().get_admin(id)
    if admin is None:
        raise AdminNotFound()

    return admin


@admins.get("/", response_model=list[AdminOut], status_code=status.HTTP_200_OK)
async def query_admins(token: str = Depends(oauth2_scheme)):
    _ = await get_user("admin", "owner", token=token)

    return await DataBaseManager().query_admins()


@admins.put("/{id}", response_model=AdminOut)
async def update_admin(
    id: int, new_admin: AdminEdit, token: str = Depends(oauth2_scheme)
):
    _ = await get_user("owner", token=token)

    if not await admin_exists(id):
        raise AdminNotFound()
    await DataBaseManager().update_admin(id, **new_admin.dict())
    return {**new_admin.dict(), "id": id}


@admins.patch("/set_image", status_code=status.HTTP_204_NO_CONTENT)
async def set_image(image: UploadFile, token: str = Depends(oauth2_scheme)):
    admin = await get_user("admin", token=token)

    if not ImagesManager().is_valid_image(image):
        raise InvalidImageForamt()

    image_url = ImagesManager().save_image(image, ImagesSubPaths.admins.value)
    await DataBaseManager().update_admin(admin.id, image_url=image_url)


@admins.patch("/reset_password", status_code=status.HTTP_204_NO_CONTENT)
async def reset_password(
    passwords_scheme: AdminResetPassword, token: str = Depends(oauth2_scheme)
):
    admin = await get_user("admin", token=token)

    if not Authentication().verify_password(
        passwords_scheme.old_password, admin.password
    ):
        raise WrongPassowrd()

    await DataBaseManager().update_admin(id, password=passwords_scheme.new_password)
