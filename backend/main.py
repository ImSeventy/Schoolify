from fastapi import FastAPI
from lib.authentication.authentication import Authentication

from lib.database.manager import DataBaseManager
from routers import majors, admins, students

app = FastAPI()
app.include_router(majors.majors)
app.include_router(admins.admins)
app.include_router(students.students)
DataBaseManager("sqlite:///database.db")
Authentication()

@app.on_event("startup")
async def startup_event():
    await DataBaseManager().connect()

@app.on_event("shutdown")
async def shutdown_event():
    await DataBaseManager().disconnect()