from fastapi import FastAPI
from lib.authentication.authentication import Authentication

from lib.database.manager import DataBaseManager
from lib.date_manager.date_manager import DateManager
from routers import majors, admins, students, subjects, absence, grades

app = FastAPI()
app.include_router(majors.majors)
app.include_router(admins.admins)
app.include_router(students.students)
app.include_router(subjects.subjects)
app.include_router(absence.absence)
app.include_router(grades.grades)
DataBaseManager("sqlite:///database.db")
DateManager(
    9,
    1,
    2,
    7,
    r"\d{4}-\d{2}-\d{2}"
)
Authentication()

@app.on_event("startup")
async def startup_event():
    await DataBaseManager().connect()

@app.on_event("shutdown")
async def shutdown_event():
    await DataBaseManager().disconnect()