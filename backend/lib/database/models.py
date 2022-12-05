from sqlalchemy import (
    MetaData,
    Table,
    Column,
    Integer,
    Float,
    String,
    ForeignKey,
    Date,
)


class DbModelsManager:
    __slots__ = (
        "meta_data",
        "students",
        "subjects",
        "grades",
        "absences",
        "majors",
        "admins",
        "owners",
        "posts",
        "likes",
        "warnings",
        "certifications",
    )

    def __init__(self, meta_data: MetaData) -> None:
        self.meta_data = meta_data
        self._create_all_tables()

    def _create_all_tables(self) -> None:
        self._create_majors_table()
        self._create_students_table()
        self._create_subjects_table()
        self._create_grades_table()
        self._create_absences_table()
        self._create_admins_table()
        self._create_owners_table()
        self._create_posts_table()
        self._create_likes_table()
        self._create_warnings_table()
        self._create_certifications_table()

    def _create_students_table(self) -> None:
        self.students = Table(
            "students",
            self.meta_data,
            Column("id", Integer, primary_key=True),
            Column("rf_id", Integer, unique=True),
            Column("name", String),
            Column("email", String, unique=True),
            Column("password", String),
            Column("entry_year", Integer),
            Column("major_id", ForeignKey("majors.id")),
        )

    def _create_subjects_table(self) -> None:
        self.subjects = Table(
            "subjects",
            self.meta_data,
            Column("id", Integer, primary_key=True),
            Column("name", String),
            Column("full_degree", Integer),
            Column("major_id", ForeignKey("majors.id")),
            Column("grade", Integer),
        )

    def _create_grades_table(self) -> None:
        self.grades = Table(
            "grades",
            self.meta_data,
            Column("id", Integer, primary_key=True),
            Column("student_id", ForeignKey("students.id")),
            Column("subject_id", ForeignKey("subjects.id")),
            Column("grade", Float),
            Column("semester", Integer),
        )

    def _create_absences_table(self) -> None:
        self.absences = Table(
            "absences",
            self.meta_data,
            Column("id", Integer, primary_key=True),
            Column("student_id", ForeignKey("students.id")),
            Column("date", Date),
            Column("grade", Integer),
            Column("semester", Integer),
        )

    def _create_majors_table(self) -> None:
        self.majors = Table(
            "majors",
            self.meta_data,
            Column("id", Integer, primary_key=True),
            Column("name", String),
        )

    def _create_admins_table(self) -> None:
        self.admins = Table(
            "admins",
            self.meta_data,
            Column("id", Integer, primary_key=True),
            Column("name", String),
            Column("role", String),
            Column("email", String, unique=True),
            Column("password", String),
        )

    def _create_owners_table(self) -> None:
        self.owners = Table(
            "owners",
            self.meta_data,
            Column("id", Integer, primary_key=True),
            Column("name", String),
            Column("email", String, unique=True),
            Column("password", String),
        )

    def _create_posts_table(self) -> None:
        self.posts = Table(
            "posts",
            self.meta_data,
            Column("id", Integer, primary_key=True),
            Column("content", String),
            Column("image_url", String),
            Column("by", ForeignKey("admins.id"))
        )

    def _create_likes_table(self) -> None:
        self.likes = Table(
            "likes",
            self.meta_data,
            Column("id", Integer, primary_key=True),
            Column("by", ForeignKey("students.id")),
            Column("post_id", ForeignKey("posts.id"))
        )

    def _create_warnings_table(self) -> None:
        self.warnings = Table(
            "warnings",
            self.meta_data,
            Column("id", Integer, primary_key=True),
            Column("content", String),
            Column("student_id", ForeignKey("students.id")),
            Column("date", Date),
            Column("grade_year", Integer),
            Column("semester", Integer),
        )

    def _create_certifications_table(self) -> None:
        self.certifications = Table(
            "certifications",
            self.meta_data,
            Column("id", Integer, primary_key=True),
            Column("content", String),
            Column("image_url", String),
            Column("student_id", ForeignKey("students.id")),
            Column("date", Date)
        )
