import re
from datetime import datetime

from lib.singleton_handler import Singleton
from constants.enums import Semesters

class DateManager(metaclass=Singleton):
    __slots__ = ("first_semester_start", "first_semester_end", "sencond_semester_start", "second_semester_end", "required_date_format")

    def __init__(
        self,
        first_semester_start: int,
        first_semester_end: int,
        sencond_semester_start: int,
        second_semester_end: int,
        required_date_format: str,
        ) -> None:
        self.first_semester_start = first_semester_start
        self.first_semester_end = first_semester_end
        self.sencond_semester_start = sencond_semester_start
        self.second_semester_end = second_semester_end
        self.required_date_format = re.compile(required_date_format)

    def get_current_semester(self, date: datetime) -> Semesters:
        if date.month >= self.sencond_semester_start and date.month <= self.second_semester_end:
            return Semesters.second_semester
        else:
            return Semesters.first_semester

    def get_current_grade(self, entry_year: int) -> int:
        current_date = datetime.utcnow()
        current_grade = current_date.year - entry_year
        if current_date.month > self.first_semester_start:
            current_grade += 1
        
        return min(5, current_grade)

    def is_proper_format(self, date: str) -> bool:
        return self.required_date_format.fullmatch(date) is not None