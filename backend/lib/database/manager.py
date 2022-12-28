from __future__ import annotations
from typing import TYPE_CHECKING
from databases import Database
from sqlalchemy import create_engine, MetaData
from sqlalchemy import text

from lib.database.models import DbModelsManager
from lib.singleton_handler import Singleton
from models.certifications_models import CertificationEditFormModel, CertificationFormModel, CertificationOut
from models.grades_models import Grade, GradeIn
from models.posts_models import PostFormModel

if TYPE_CHECKING:
    from models.admins_models import Admin, AdminIn
    from models.majors_models import MajorEdit, MajorIn, MajorOut
    from models.students_models import Student, StudentIn
    from models.absences_models import AbsenceIn
    from models.absences_models import Absence
    from models.subjects_models import Subject, SubjectIn
    from models.posts_models import Post, PostEdit, PostOut
    from models.warnings_models import WarningIn, Warning, WarningEdit, WarningOut
    from models.likes_models import Like
    from models.owners_models import Owner


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
            query = self.models_manager.admins.select().where(self.models_manager.admins.c.email == id_or_email)

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

    async def get_student_by_rfid(self, rfid: int) -> Student | None:
        query = "SELECT * FROM students where students.rf_id = :rfid"

        return await self.db.fetch_one(query, values={"rfid": rfid})

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

    async def get_student_absences(self, student_id: int, grade: int = None, semester: int = None) -> list[Absence]:
        query = f"""
        SELECT *, :grade, :semester FROM absences
        WHERE absences.student_id = :student_id
        {'AND absences.grade = :grade' if grade is not None else ''}
        {'AND absences.semester = :semester' if semester is not None else ''}
        """
        return await self.db.fetch_all(query, {"student_id": student_id, "grade": grade, "semester": semester})
    
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
        subjects.grade as grade_year
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
        subjects.grade as grade_year
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

    async def add_new_post(self, post: PostFormModel) -> int:
        query = self.models_manager.posts.insert().values(**post.as_dict())
        return await self.db.execute(query)

    async def get_owner(self, id_or_email: int | str) -> Owner | None:
        query = f"""
        SELECT *  FROM owners WHERE {'owners.email = :id_or_email' if isinstance(id_or_email, str) else 'owners.id = :id_or_email'}
        """
        return await self.db.fetch_one(query, {"id_or_email": id_or_email})

    async def get_post_from_id(self, post_id: int) -> Post | None:
        query = """
        SELECT posts.*,
        (SELECT COUNT(*) FROM likes where likes.post_id = :post_id) as like_count,
        admins.name as by_name,
        admins.image_url as by_image_url
        FROM posts JOIN admins
        ON posts.by = admins.id
        WHERE posts.id = :post_id;
        """
        return await self.db.fetch_one(query, {"post_id": post_id})

    async def get_all_posts(self, user_id: int = None) -> list[PostOut]:
        query = """
        SELECT posts.*,
        :user_id,
        COUNT(likes.post_id) as like_count,
        (CASE WHEN likes.by = :user_id THEN true ELSE false END) as liked,
        admins.name as by_name,
        admins.image_url as by_image_url
        FROM posts LEFT JOIN admins LEFT JOIN likes
        ON posts.id = likes.post_id
        AND posts.by = admins.id
        group by posts.id;
        """
        return await self.db.fetch_all(query, {"user_id": user_id})

    async def delete_post_with_id(self, id: int) -> None:
        query = self.models_manager.posts.delete().where(self.models_manager.posts.c.id == id)
        await self.db.execute(query)

    async def edit_post(self, id: int, new_post: PostEdit) -> None:
        query = self.models_manager.posts.update().where(self.models_manager.posts.c.id == id).values(**new_post.dict())
        await self.db.execute(query)

    async def add_new_like(self, **kwagrs) -> int:
        query = self.models_manager.likes.insert().values(**kwagrs)
        return await self.db.execute(query)

    async def get_like(self, post_id: int, user_id: int) -> Like | None:
        query = """
        SELECT * FROM likes WHERE likes.post_id = :post_id AND likes.by = :user_id
        """
        return await self.db.fetch_one(query, {"post_id": post_id, "user_id": user_id})

    async def get_like_from_id(self, like_id: int) -> Like:
        query = """
        SELECT * FROM likes WHERE likes.id = :like_id;
        """
        return await self.db.fetch_one(query, {"like_id": like_id})

    async def get_user_id_from_like_id(self, like_id: int) -> int:
        query = """
        SELECT by FROM likes WHERE likes.id = :like_id;
        """
        return await self.db.fetch_one(query, {"like_id": like_id})

    async def delete_like(self, post_id: int, user_id: int) -> None:
        query = self.models_manager.likes.delete().where(
            self.models_manager.likes.c.post_id == post_id,
            self.models_manager.likes.c.by == user_id
        )
        await self.db.execute(query)

    async def add_new_warning(self, warning: WarningIn) -> int:
        query = self.models_manager.warnings.insert().values(**warning.dict())
        return await self.db.execute(query)

    async def get_warning_from_id(self, warning_id: int) -> Warning | None:
        query = self.models_manager.warnings.select().where(self.models_manager.warnings.c.id == warning_id)
        return await self.db.fetch_one(query)

    async def delete_warning_with_id(self, id: int) -> None:
        query = self.models_manager.warnings.delete().where(self.models_manager.warnings.c.id == id)
        await self.db.execute(query)

    async def edit_warning(self, id: int, new_warning: WarningEdit) -> None:
        query = self.models_manager.warnings.update().where(self.models_manager.warnings.c.id == id).values(**new_warning.dict())
        await self.db.execute(query)

    async def get_all_warnings(self, student_id: int) -> list[WarningOut]:
        query = """
        SELECT * FROM warnings WHERE warnings.student_id = :student_id
        """
        return await self.db.fetch_all(query, {"student_id": student_id})

    async def get_warning_from_id(self, warning_id: int) -> WarningOut:
        query = self.models_manager.warnings.select().where(self.models_manager.warnings.c.id == warning_id)
        return await self.db.fetch_one(query)

    async def create_certification(self, cert: CertificationFormModel) -> int:
        query = self.models_manager.certifications.insert().values(**cert.as_dict())
        return await self.db.execute(query)

    async def get_certification_from_id(self, cert_id: int) -> CertificationOut:
        query = """
        SELECT certifications.*,
        admins.name as given_by_name,
        admins.image_url as given_by_image_url
        FROM certifications
        JOIN admins ON certifications.given_by = admins.id
        WHERE certifications.id = :cert_id
        """
        return await self.db.fetch_one(query, {"cert_id": cert_id})

    async def get_student_certifications(self, student_id: int) -> list[CertificationOut]:
        query = """
        SELECT certifications.*,
        admins.name as given_by_name,
        admins.image_url as given_by_image_url
        FROM certifications
        JOIN admins ON certifications.given_by = admins.id
        WHERE certifications.student_id = :student_id
        """
        return await self.db.fetch_all(query, {"student_id": student_id})

    async def delete_certification_with_id(self, id: int) -> None:
        query = self.models_manager.certifications.delete().where(self.models_manager.certifications.c.id == id)
        await self.db.execute(query)

    async def edit_certification(self, id: int, new_cert: CertificationEditFormModel) -> None:
        query = self.models_manager.certifications.update().where(self.models_manager.certifications.c.id == id).values(**new_cert.as_dict())
        await self.db.execute(query)