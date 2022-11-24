from fastapi import APIRouter, status, Depends
from lib.authentication.authentication import oauth2_scheme, get_user
from lib.database.manager import DataBaseManager
from lib.exceptions.subjects import ClassAlreadyHasSubject, MajorNotFound, SubjectNotFound
from lib.checks import checks
from models.subjects_models import SubjectEdit, SubjectIn, SubjectOut


subjects = APIRouter(
    prefix="/subjects",
    tags=["subjects"]
)

@subjects.get("/class", response_model=list[SubjectOut], status_code=status.HTTP_200_OK)
async def query_class_subjects(major_id: int, grade: int, token: str = Depends(oauth2_scheme)):
    _ = await get_user("admin", "student", token=token)

    return await DataBaseManager().query_class_subjects(major_id, grade)


@subjects.get("/{id}", response_model=SubjectOut, status_code=status.HTTP_200_OK)
async def get_subject(id: int, token: str = Depends(oauth2_scheme)):
    _ = await get_user("admin", "student", token=token)

    subject = await DataBaseManager().get_subject(id)
    if subject is None:
        raise SubjectNotFound()
    
    return subject


@subjects.post("/", response_model=SubjectOut, status_code=status.HTTP_201_CREATED)
async def create_subject(subject: SubjectIn, token: str = Depends(oauth2_scheme)):
    _ = await get_user("admin", token=token)

    major = await DataBaseManager().get_major(subject.major_id)
    if major is None:
        raise MajorNotFound()

    if await checks.class_has_subject(subject.major_id, subject.grade, subject.name):
        raise ClassAlreadyHasSubject()

    id = await DataBaseManager().create_subject(subject)
    return {**subject.dict(), "major_name": major.name, "id": id}


@subjects.put("/{id}", status_code=status.HTTP_204_NO_CONTENT)
async def update_subject(id: int, new_subject: SubjectEdit, token: str = Depends(oauth2_scheme)):
    _ = await get_user("admin", token=token)

    if not await checks.subject_exists(id):
        raise SubjectNotFound()
    
    await DataBaseManager().update_subject(id, **new_subject.dict())


@subjects.delete("/{id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_subject(id: int, token: str = Depends(oauth2_scheme)):
    _ = await get_user("admin", token=token)

    if not await checks.subject_exists(id):
        raise SubjectNotFound()

    await DataBaseManager().delete_subject(id)