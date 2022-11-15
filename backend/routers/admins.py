from fastapi import APIRouter, status
from sqlite3 import IntegrityError
from lib.authentication.authentication import Authentication
from lib.checks.checks import admin_exists
from lib.database.manager import DataBaseManager
from lib.exceptions.admins import AdminNotFound, EmailIsAlreadyUsed, WrongPassowrd

from models.admins_models import AdminEdit, AdminIn, AdminOut, AdminResetPassword


admins = APIRouter(
    prefix="/admins",
    tags=["admins"]
)


@admins.post("/", response_model=AdminOut, status_code=status.HTTP_201_CREATED)
async def create_admin(admin: AdminIn):
    try:
        id = await DataBaseManager().create_admin(admin)
    except IntegrityError:
        raise EmailIsAlreadyUsed()

    return {**admin.dict(), "id": id}


@admins.get("/{id}", response_model=AdminOut, status_code=status.HTTP_200_OK)
async def get_admin(id: int):
    admin = await DataBaseManager().get_admin(id)
    if admin is None:
        raise AdminNotFound()

    return admin


@admins.get("/", response_model=list[AdminOut], status_code=status.HTTP_200_OK)
async def query_admins():
    return await DataBaseManager().query_admins()


@admins.put("/{id}", response_model=AdminOut)
async def update_admin(id: int, new_admin: AdminEdit):
    if not await admin_exists(id):
        raise AdminNotFound()
    await DataBaseManager().update_admin(id, **new_admin.dict())
    return {**new_admin.dict(), "id": id}


@admins.patch("/reset_password/{id}", status_code=status.HTTP_204_NO_CONTENT)
async def reset_password(id: int, passwords_scheme: AdminResetPassword):
    admin = await DataBaseManager().get_admin(id)
    if admin is None:
        raise AdminNotFound()

    if not Authentication().verify_password(passwords_scheme.old_password, admin.password):
        raise WrongPassowrd()

    await DataBaseManager().update_admin(id, password=passwords_scheme.new_password)
