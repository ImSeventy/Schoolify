from enum import Enum

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


class Semesters(Enum):
    first_semester = 1
    second_semester = 2