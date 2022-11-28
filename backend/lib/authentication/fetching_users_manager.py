from __future__ import annotations
from typing import Callable, TYPE_CHECKING
from lib.database.manager import DataBaseManager
from lib.exceptions.auth import InvalidCredentials

if TYPE_CHECKING:
    from models.admins_models import Admin
    from models.students_models import Student
    from models.owners_models import Owner


def role_fetcher_decorator(role_name: str) -> Callable:
    def decorator(func: Callable) -> Callable:
        async def wrapper(token_data: dict):
            role = token_data.get("role")
            if role != role_name:
                raise InvalidCredentials()
            return await func(token_data)

        FetchingUsersManager(role_name, wrapper)
        return func

    return decorator


class FetchingUsersManager:
    __roles_fetchers__: dict[str, FetchingUsersManager] = {}
    __slots__ = ("role", "callback")

    def __init__(self, role: str, callback: Callable) -> None:
        self.role = role
        self.callback = callback
        self.__roles_fetchers__[role] = self

    @classmethod
    async def fetch_user(
        cls, roles: list[str], token_data: dict
    ) -> Student | Owner | Admin | None:
        for role in roles:
            fetcher = cls.__roles_fetchers__.get(role)
            if fetcher is None:
                continue

            user = await fetcher.callback(token_data)
            if user is None:
                continue

            return user


        raise InvalidCredentials()


@role_fetcher_decorator("student")
async def fetch_student(token_data: dict) -> Student | None:
    student_id = token_data.get("id")
    student = await DataBaseManager().get_student(student_id)
    if student is None:
        raise InvalidCredentials()

    return student


@role_fetcher_decorator("owner")
async def fetch_owner(token_data: dict) -> Owner | None:
    owner_id = token_data.get("id")
    owner = await DataBaseManager().get_owner(owner_id)
    if owner is None:
        raise InvalidCredentials()

    return owner


@role_fetcher_decorator("admin")
async def fetch_admin(token_data: dict) -> Admin | None:
    admin_id = token_data.get("id")
    admin = await DataBaseManager().get_admin(admin_id)
    if admin is None:
        raise InvalidCredentials()

    return admin