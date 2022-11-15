from lib.database.manager import DataBaseManager


async def major_exists(id_or_name: int | str) -> bool:
    major = await DataBaseManager().get_major(id_or_name)
    return True if major else False


async def admin_exists(id_or_email: int | str) -> bool:
    admin = await DataBaseManager().get_admin(id_or_email)
    return True if admin else False


async def student_exists(id_or_email: int | str) -> bool:
    student = await DataBaseManager().get_student(id_or_email)
    return True if student else False


async def subject_exists(id: int) -> bool:
    subject = await DataBaseManager().get_subject(id)
    return True if subject else False

# async def absense_exists(id: int, date: DateTime) -> bool:
#     absence = await DataBaseManager().get_absence_date(id, date)
#     return True if absence else False

async def class_has_subject(major_id: id, grade: int, subject_name: str) -> bool:
    subject = await DataBaseManager().get_class_subject(major_id, grade, subject_name)
    return True if subject else False