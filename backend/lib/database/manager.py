from __future__ import annotations
from typing import TYPE_CHECKING
from databases import Database
from sqlalchemy import create_engine, MetaData

from lib.database.models import DbModelsManager
from lib.singleton_handler import Singleton
from models.subjects_models import Subject, SubjectIn

if TYPE_CHECKING:
    from models.admins_models import Admin, AdminEdit, AdminIn, AdminOut
    from models.majors_models import MajorEdit, MajorIn, MajorOut
    from models.students_models import Student, StudentIn
    from models.absences_models import AbsenceIn, AbsenceOut, AbsenceEdit


class DataBaseManager(metaclass=Singleton):
    def __init__(self, db_url: str):
        self.db_url = db_url
        self.db = Database(self.db_url)
        meta_data = MetaData()
        self.models_manager = DbModelsManager(meta_data)
        engine = create_engine(self.db_url, connect_args={"check_same_thread": False})
        meta_data.create_all(engine)

    async def connect(self) -> None:
        await self.db.connect()

    async def disconnect(self) -> None:
        await self.db.disconnect()

    async def create_major(self, major: MajorIn) -> int:
        query = self.models_manager.majors.insert().values(**major.dict())
        return await self.db.execute(query)

    async def delete_major(self, id: int) -> None:
        query = self.models_manager.majors.delete().where(self.models_manager.majors.c.id == id)
        await self.db.execute(query)

    async def update_major(self, id: int, new_major: MajorEdit) -> None:
        query = self.models_manager.majors.update().where(self.models_manager.majors.c.id == id).values(**new_major.dict())
        await self.db.execute(query)

    async def get_major(self, id_or_name: int | str) -> MajorOut | None:
        if isinstance(id_or_name, int):
            query = self.models_manager.majors.select().where(self.models_manager.majors.c.id == id_or_name)
        else:
            query = self.models_manager.majors.select().where(self.models_manager.majors.c.name == id_or_name)

        return await self.db.fetch_one(query)

    async def query_majors(self) -> list[MajorOut]:
        query = self.models_manager.majors.select()
        return await self.db.fetch_all(query)

    async def create_admin(self, admin: AdminIn) -> int:
        query = self.models_manager.admins.insert().values(**admin.dict())
        return await self.db.execute(query)

    async def get_admin(self, id_or_email: str | int) -> Admin | None:
        if isinstance(id_or_email, int):
            query = self.models_manager.admins.select().where(self.models_manager.admins.c.id == id_or_email)
        else:
            query = self.models_manager.admins.select().where(self.models_manager.admins.c.name == id_or_email)

        return await self.db.fetch_one(query)

    async def query_admins(self) -> list[Admin]:
        query = self.models_manager.admins.select()
        return await self.db.fetch_all(query)

    async def update_admin(self, id: int, **fields) -> None:
        query = self.models_manager.admins.update().where(self.models_manager.admins.c.id == id).values(**fields)
        return await self.db.execute(query)

    async def get_student(self, id_or_email: str | int) -> Student | None:
        if isinstance(id_or_email, int):
            query = "SELECT *, (SELECT name from majors WHERE majors.id = students.major_id) as major_name FROM students where students.id = :id_or_email"
        else:
            query = "SELECT *, (SELECT name from majors WHERE majors.id = students.major_id) as major_name FROM students where students.email = :id_or_email"

        return await self.db.fetch_one(query, values={"id_or_email": id_or_email})

    async def get_major_students(self, id: int) -> list[Student]:
        query = self.models_manager.students.select().where(self.models_manager.students.c.major_id == id)
        return await self.db.fetch_all(query)

    # async def query_class_students(self, major_id: int, grade: int) -> list[Student]:
    #     query = """
    #     SELECT * FROM students
    #     WHERE students.major_id = :major_id,
    #     """
    #     return await self.db.fetch_all(query, {"major_id": major_id, "grade": grade})

    async def create_studnet(self, student: StudentIn) -> int:
        query = self.models_manager.students.insert().values(**student.dict())
        return await self.db.execute(query)

    async def update_student(self, id: int, **fields) -> None:
        query = self.models_manager.students.update().where(self.models_manager.students.c.id == id).values(**fields)
        return await self.db.execute(query)

    async def delete_student(self, id: int) -> None:
        query = self.models_manager.students.delete().where(self.models_manager.students.c.id == id)
        await self.db.execute(query)

    async def create_subject(self, subject: SubjectIn) -> int:
        query = self.models_manager.subjects.insert().values(**subject.dict())
        return await self.db.execute(query)

    async def get_subject(self, id: int) -> Subject | None:
        query = """
        SELECT *, (SELECT name FROM majors WHERE majors.id = subjects.major_id) as major_name
        FROM subjects
        WHERE subjects.id = :id 
        """
        return await self.db.fetch_one(query, {"id": id})

    async def get_class_subject(self, major_id: id, grade: int, subject_name: str) -> Subject | None:
        query = """
        SELECT * FROM subjects
        WHERE major_id = :major_id
        AND grade = :grade
        AND name = :subject_name
        """
        return await self.db.fetch_one(query, {"major_id": major_id, "grade": grade, "subject_name": subject_name})

    async def query_class_subjects(self, major_id: int, grade: int) -> list[Subject]:
        query = """
        SELECT subjects.*, majors.name as major_name
        FROM subjects JOIN majors
        ON majors.id == subjects.major_id
        WHERE major_id = :major_id AND grade = :grade
        """
        return await self.db.fetch_all(query, {"major_id": major_id, "grade": grade})

    async def update_subject(self, id: int, **values) -> None:
        query = self.models_manager.subjects.update().where(self.models_manager.subjects.c.id == id).values(**values)
        return await self.db.execute(query)

    async def delete_subject(self, id: int) -> None:
        query = self.models_manager.subjects.delete().where(self.models_manager.subjects.c.id == id)
        return await self.db.execute(query)

    # async def get_absence_date(self, id: int, date: DateTime) -> None:
    #     query = """
    #     SELECT * FROM absences
    #     WHERE student_id = :student_id
    #     AND date = :date
    #     """
    #     return await self.db.fetch_one(query, {"student_id": id, "date": date})

