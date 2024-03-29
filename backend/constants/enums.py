from enum import Enum, auto

class Roles(Enum):
    teacher = "teacher"
    moderator = "moderator"
    manager = "manager"

    @classmethod
    def exists(cls, role: str):
        for r in cls:
            if r.value == role:
                return True

        return False

class ImagesSubPaths(Enum):
    posts = "posts"
    users = "students"
    certifications = "certifications"
    admins = "admins"
    students = "students"

class Semesters(Enum):
    first_semester = 1
    second_semester = 2


class TokenTypes(Enum):
    ACCESS_TOKEN = auto()
    REFRESH_TOKEN = auto()