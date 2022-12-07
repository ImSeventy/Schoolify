from datetime import datetime
from fastapi import APIRouter, status, Depends
from fastapi.responses import FileResponse
from constants.enums import ImagesSubPaths
from lib.database.manager import DataBaseManager
from lib.exceptions.certifications import CertificationNotFound, ImageNotFound, InvalidImageFormat, StudentIsnotCertificationOwner, StudentNotFound
from models.certifications_models import CertificationEditFormModel, CertificationFormModel, CertificationOut
from lib.authentication.authentication import get_user, oauth2_scheme
from lib.images_manager.images_manager import ImagesManager
from lib.checks.checks import certification_exists, student_exists
from lib.date_manager.date_manager import DateManager

certifications = APIRouter(
    prefix="/certifications",
    tags=["certifications"],
)


@certifications.post("/", status_code=status.HTTP_201_CREATED, response_model=CertificationOut)
async def create_certification(certification: CertificationFormModel = Depends(), token: str = Depends(oauth2_scheme)):
    admin = await get_user("admin", token=token)

    student = await DataBaseManager().get_student(certification.student_id)
    if student is None:
        raise StudentNotFound()

    if certification.image is not None:
        if not ImagesManager().is_valid_image(certification.image):
            raise InvalidImageFormat()

        image_url = ImagesManager().save_image(certification.image, ImagesSubPaths.certifications.value)
        certification.image_url = image_url

    certification.given_by = admin.id
    certification.grade_year = DateManager().get_current_grade(student.entry_year)
    certification.semester = DateManager().get_current_semester(datetime.utcnow()).value

    id = await DataBaseManager().create_certification(certification)

    return {
        **certification.as_dict(),
        "id": id,
        "given_by": admin.id,
        "given_by_name": admin.name,
        "given_by_image_url": admin.image_url
    }


@certifications.get("/me", status_code=status.HTTP_200_OK, response_model=list[CertificationOut])
async def get_my_certifications(token: str = Depends(oauth2_scheme)):
    student = await get_user("student", token=token)
    return await DataBaseManager().get_student_certifications(student.id)


@certifications.get("/student/{id}", status_code=status.HTTP_200_OK, response_model=list[CertificationOut])
async def get_student_certifications(id: int, token: str = Depends(oauth2_scheme)):
    _ = await get_user("admin", token=token)

    if not await student_exists(id):
        raise StudentNotFound()

    return await DataBaseManager().get_student_certifications(id)


@certifications.get("/{id}", status_code=status.HTTP_200_OK, response_model=CertificationOut)
async def get_certification(id: int, token: str = Depends(oauth2_scheme)):
    user = await get_user("admin", "student", token=token)
    cert = await DataBaseManager().get_certification_from_id(id)
    if cert is None:
        raise CertificationNotFound()

    if getattr(user, "role", None) is None and cert.student_id != user.id:
        raise StudentIsnotCertificationOwner()

    return cert


@certifications.delete("/{id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_certification(id: int, token: str = Depends(oauth2_scheme)):
    _ = await get_user("admin", token=token)

    if not await certification_exists(id):
        raise CertificationNotFound()

    await DataBaseManager().delete_certification_with_id(id)


@certifications.put("/{id}", status_code=status.HTTP_204_NO_CONTENT)
async def edit_certification(id: int, certification: CertificationEditFormModel = Depends(), token: str = Depends(oauth2_scheme)):
    _ = await get_user("admin", token=token)

    cert = await DataBaseManager().get_certification_from_id(id)
    if cert is None:
        raise CertificationNotFound()

    if certification.image is not None:
        if not ImagesManager().is_valid_image(certification.image):
            raise InvalidImageFormat()

        image_url = ImagesManager().save_image(certification.image, ImagesSubPaths.certifications.value)
        certification.image_url = image_url
    else:
        certification.image_url = cert.image_url

    await DataBaseManager().edit_certification(id, certification)


@certifications.get("/image/{image_name}")
async def get_image(image_name: str):
    if not ImagesManager().image_exists(image_name, ImagesSubPaths.certifications.value):
        raise ImageNotFound()

    return FileResponse(ImagesManager().get_image_path(image_name, ImagesSubPaths.certifications.value))