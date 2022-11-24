from fastapi import APIRouter, status, Depends
from lib.authentication.authentication import Authentication, oauth2_scheme, get_user
from lib.database.manager import DataBaseManager
from lib.checks.checks import major_exists
from lib.exceptions.majors import MajorNotFound
from models.majors_models import MajorEdit, MajorIn, MajorOut


majors = APIRouter(
    prefix="/majors",
    tags=["majors"]
)


@majors.get("/", response_model=list[MajorOut])
async def get_all_majors(token: str = Depends(oauth2_scheme)):
    _ = await get_user("admin", "student", token=token)
    return await DataBaseManager().query_majors()


@majors.get("/{id}", response_model=MajorOut)
async def get_major(id: int, token: str = Depends(oauth2_scheme)):
    _ = await get_user("admin", "student", token=token)
    major = await DataBaseManager().get_major(id)
    if major is None:
        raise MajorNotFound()

    return major


@majors.post("/", response_model=MajorOut, status_code=status.HTTP_201_CREATED)
async def create_major(major: MajorIn, token: str = Depends(oauth2_scheme)):
    _ = await get_user("admin", token=token)

    id = await DataBaseManager().create_major(major)
    return {**major.dict(), "id": id}


@majors.delete("/{id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_major(id: int, token: str = Depends(oauth2_scheme)):
    _ = await get_user("admin", token=token)

    if not await major_exists(id):
        raise MajorNotFound()

    await DataBaseManager().delete_major(id)


@majors.put("/{id}", response_model=MajorOut)
async def update_major(id: int, new_major: MajorEdit, token: str = Depends(oauth2_scheme)):
    _ = await get_user("admin", token=token)

    if not await major_exists(id):
        raise MajorNotFound()

    await DataBaseManager().update_major(id, new_major)

    return {**new_major.dict(), "id": id}