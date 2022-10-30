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