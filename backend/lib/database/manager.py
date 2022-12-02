from __future__ import annotations
from typing import TYPE_CHECKING
from databases import Database
from sqlalchemy import create_engine, MetaData
from sqlalchemy import text

from lib.database.models import DbModelsManager
from lib.singleton_handler import Singleton
from models.grades_models import Grade, GradeIn

if TYPE_CHECKING:
    from models.admins_models import Admin, AdminIn
    from models.majors_models import MajorEdit, MajorIn, MajorOut
    from models.students_models import Student, StudentIn
    from models.absences_models import AbsenceIn
    from models.absences_models import Absence
    from models.subjects_models import Subject, SubjectIn


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
    
    async def get_student_subject(self, student_id: int, subject_id: int) -> Subject | None:
        query = """
        SELECT * FROM students
        JOIN subjects
        ON students.major_id = subjects.major_id
        WHERE students.id = :student_id
        AND subjects.id = :subject_id
        """
        return await self.db.fetch_one(query, {"student_id": student_id, "subject_id": subject_id})

    async def update_subject(self, id: int, **values) -> None:
        query = self.models_manager.subjects.update().where(self.models_manager.subjects.c.id == id).values(**values)
        return await self.db.execute(query)

    async def delete_subject(self, id: int) -> None:
        query = self.models_manager.subjects.delete().where(self.models_manager.subjects.c.id == id)
        return await self.db.execute(query)

    async def get_student_absence(self, student_id: int, date: str = None) -> Absence | None:
        query = f"""
        SELECT *, :date FROM absences WHERE absences.student_id = :student_id AND absences.date = {'DATE()' if date is None else 'STRFTIME(:date)'};
        """
        return await self.db.fetch_one(query, {"student_id": student_id, "date": date})

    async def set_student_as_absent_today(self, absence: AbsenceIn) -> int:
        query = self.models_manager.absences.insert().values(**absence.dict())
        return await self.db.execute(query)

    async def get_absence_from_id(self, absence_id: int):
        query = """
        SELECT * FROM absences WHERE absences.id = :absence_id;
        """
        return await self.db.fetch_one(query, {"absence_id": absence_id})

    async def delete_absence_with_id(self, id: int) -> int:
        query = self.models_manager.absences.delete().where(self.models_manager.absences.c.id == id)
        return await self.db.execute(query)

    async def delete_student_today_absence(self, student_id: int) -> None:
        query = """
        DELETE FROM absences WHERE absences.student_id = :student_id AND absences.date = DATE();
        """
        return await self.db.execute(query, {"student_id": student_id})

    async def delete_student_absence_at_date(self, student_id: int, date: str) -> None:
        query = """
        DELETE FROM absences WHERE absences.student_id = :student_id AND absences.date = STRFTIME(:date);
        """
        return await self.db.execute(query, {"student_id": student_id, "date": date})

    async def get_student_absences(self, student_id: int) -> list[Absence]:
        query = self.models_manager.absences.select().where(self.models_manager.absences.c.student_id == student_id)
        return await self.db.fetch_all(query)
    
    async def get_student_grade_absences(self, student_id: int, grade: int, semester: int = None) -> list[Absence]:
        query = f"""
        SELECT *, :semester FROM absences
        WHERE absences.student_id = :student_id
        AND absences.grade = :grade
        {' AND absences.semester = :semester' if semester is not None else ''};
        """
        return await self.db.fetch_all(query, {"student_id": student_id, "grade": grade, "semester": semester})
   
    async def get_grade(
        self,
        student_id: int,
        subject_id: int,
        semester: int
    ) -> Grade | None:
        query = """
        SELECT grades.*,
        subjects.name as subject_name,
        subjects.full_degree as full_degree,
        subjects.grade as grade_year,
        FROM grades JOIN subjects
        ON grades.subject_id = subjects.id
        WHERE grades.student_id = :student_id
        AND grades.subject_id = :subject_id
        AND grades.semester = :semester
        """
        return await self.db.fetch_one(query, {"student_id": student_id, "subject_id": subject_id, "semester": semester})

    async def get_grade_with_id(self, grade_id: int) -> Grade | None:
        query = """
        SELECT grades.*,
        subjects.name as subject_name,
        subjects.full_degree as full_degree,
        subjects.grade as grade_year,
        FROM grades
        JOIN subjects
        ON grades.subject_id = subjects.id
        WHERE grades.id = :grade_id;
        """
        return await self.db.fetch_one(query, {"grade_id": grade_id})

    async def create_grade(self, grade: GradeIn) -> int:
        query = self.models_manager.grades.insert().values(**grade.dict())
        return await self.db.execute(query)

    async def update_grade(self, id: int, **values) -> None:
        query = self.models_manager.grades.update().where(self.models_manager.grades.c.id == id).values(**values)
        return await self.db.execute(query)

    async def delete_grade_with_id(self, id: int) -> None:
        query = self.models_manager.grades.delete().where(self.models_manager.grades.c.id == id)
        return await self.db.execute(query)

    async def delete_grade(self, student_id: int, subject_id: int, semester: int) -> None:
        query = self.models_manager.grades.delete().where(
            self.models_manager.grades.c.student_id == student_id,
            self.models_manager.grades.c.subject_id == subject_id,
            self.models_manager.grades.c.semester == semester
        )
        return await self.db.execute(query)

    async def get_student_grades(
        self,
        student_id: int,
        grade: int = None,
        semester: int = None,
        subject_id: int = None
    ) -> list[Grade]:
        query = f"""
        SELECT grades.*,
        subjects.name as subject_name,
        subjects.full_degree as full_degree,
        subjects.grade as grade_year,
        :grade,
        :semester,
        :subject_id
        FROM grades
        JOIN subjects
        ON grades.subject_id = subjects.id
        WHERE grades.student_id = :student_id
        {'AND subjects.grade = :grade' if grade else ''}
        {'AND grades.semester = :semester' if semester else ''}
        {'AND grades.subject_id = :subject_id' if subject_id else ''}
        """
        return await self.db.fetch_all(query, {"student_id": student_id, "grade": grade, "semester": semester, "subject_id": subject_id})
