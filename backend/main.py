from fastapi import FastAPI
from lib.authentication.authentication import Authentication
from lib.images_manager.images_manager import ImagesManager
from lib.database.manager import DataBaseManager
from lib.date_manager.date_manager import DateManager
from models.settings_models import Settings
from routers import (
    majors,
    admins,
    students,
    subjects,
    absence,
    grades,
    posts,
    owners,
    warnings,
)

app = FastAPI()
app.include_router(majors.majors)
app.include_router(admins.admins)
app.include_router(students.students)
app.include_router(subjects.subjects)
app.include_router(absence.absence)
app.include_router(grades.grades)
app.include_router(posts.posts)
app.include_router(owners.owners)
app.include_router(warnings.warnings)

settings = Settings()

DataBaseManager("sqlite:///database.db")
DateManager(
    settings.first_semester_start_month,
    settings.first_semester_end_month,
    settings.second_semester_start_month,
    settings.second_semester_end_month,
    r"\d{4}-\d{2}-\d{2}",
)
Authentication(
    settings.access_token_secret_key,
    settings.refresh_token_secret_key,
    settings.algorithm,
    settings.access_token_expire_minutes,
    settings.refresh_token_expire_days,
)
ImagesManager(settings.images_path, settings.ip_address)


@app.on_event("startup")
async def startup_event():
    await DataBaseManager().connect()


@app.on_event("shutdown")
async def shutdown_event():
    await DataBaseManager().disconnect()
