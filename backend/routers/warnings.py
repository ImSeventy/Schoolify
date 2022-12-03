from fastapi import APIRouter, status, Depends
from constants.enums import Roles
from lib.database.manager import DataBaseManager
from lib.exceptions.auth import InvalidCredentials
from lib.exceptions.warnings import StudentNotFound, WarningNotFound, ThisWarningNotYours
from models.warnings_models import WarningIn, WarningOut, WarningEdit
from lib.authentication.authentication import oauth2_scheme, get_user
from lib.checks.checks import student_exists, warning_exists


warnings = APIRouter(prefix="/warnings", tags=["warnings"])

@warnings.post("/", response_model=WarningOut, status_code=status.HTTP_201_CREATED)
async def add_warning(warning: WarningIn, token: str = Depends(oauth2_scheme)):
    admin = await get_user("admin", token=token)
    if admin.role != Roles.manager.value:
        raise InvalidCredentials()
    
    if not await student_exists(warning.by):
        raise StudentNotFound()
        
    id = await DataBaseManager().add_new_warning(warning)
    return {**warning.dict(), "id": id}

@warnings.delete("/{id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_warning(id: int, token: str = Depends(oauth2_scheme)):
    admin = await get_user("admin", token=token)
    if admin.role != Roles.manager.value:
        raise InvalidCredentials()

    if not await warning_exists(id):
        raise WarningNotFound()

    await DataBaseManager().delete_warning_with_id(id)

@warnings.put("/{id}", status_code=status.HTTP_204_NO_CONTENT)
async def edit_warning(id: int, warning: WarningEdit, token: str = Depends(oauth2_scheme)):
    admin = await get_user("admin", token=token)
    if admin.role != Roles.manager.value:
        raise InvalidCredentials()

    if not await warning_exists(id):
        raise WarningNotFound()

    await DataBaseManager().edit_warning(id, warning)

@warnings.get("/me", response_model=list[WarningOut], status_code=status.HTTP_200_OK)
async def get_my_warnings(token: str = Depends(oauth2_scheme)):
    user = await get_user("student", token=token)
    
    return await DataBaseManager().get_all_warnings(user.id)

@warnings.get("/student", response_model=list[WarningOut], status_code=status.HTTP_200_OK)
async def get_student_warnings(student_id: int, token: str = Depends(oauth2_scheme)):
    _ = await get_user("admin", token=token)
    
    if not await student_exists(student_id):
        raise StudentNotFound()
    
    return await DataBaseManager().get_all_warnings(student_id)

@warnings.get("/{id}", response_model=WarningOut, status_code=status.HTTP_200_OK)
async def get_warning(id: int, token: str = Depends(oauth2_scheme)):
    user = await get_user("admin", "student", token=token)
    
    warning = await DataBaseManager().get_warning_from_id(id)
    if warning is None:
        raise WarningNotFound()
    
    if getattr(user, "role", None) is None and warning.by != user.id:
            raise ThisWarningNotYours()
    
    return warning