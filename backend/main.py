from fastapi import FastAPI

from lib.database.manager import DataBaseManager
from routers import majors

app = FastAPI()
app.include_router(majors.majors)
DataBaseManager("sqlite:///database.db")

@app.on_event("startup")
async def startup_event():
    await DataBaseManager().connect()

@app.on_event("shutdown")
async def shutdown_event():
    await DataBaseManager().disconnect()