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

async def class_has_subject(major_id: id, grade: int, subject_name: str) -> bool:
    subject = await DataBaseManager().get_class_subject(major_id, grade, subject_name)
    return True if subject else False

async def student_is_absent_today(student_id: int) -> bool:
    student_absence = await DataBaseManager().get_student_absence(student_id)
    return True if student_absence else False

async def student_is_absent_at_date(student_id: int, date: str) -> bool:
    student_absence = await DataBaseManager().get_student_absence(student_id, date)
    return True if student_absence else False

async def absence_exists(absence_id: int):
    absence = await DataBaseManager().get_absence_from_id(absence_id)
    return True if absence else False

async def post_exists(post_id: int) -> bool:
    post = await DataBaseManager().get_post_from_id(post_id=post_id)
    return True if post else False

async def like_exists(like_id: int) -> bool:
    like = await DataBaseManager().get_like_from_id(like_id= like_id)
    return True if like else False

async def grade_already_exists(
    *,
    id: int = None,
    student_id: int = None,
    subject_id: int = None,
    semester: int = None
    ) -> bool:
    if id is not None:
        grade = await DataBaseManager().get_grade_with_id(id)
    else:
        grade = await DataBaseManager().get_grade(student_id, subject_id, semester)

    return True if grade else False

async def student_has_subject(student_id: int, subject_id: int) -> bool:
    subject = await DataBaseManager().get_subject(subject_id)
    if not subject:
        return False
    if subject.major_name == "general":
        return True
    student_subject = await DataBaseManager().get_student_subject(student_id, subject_id)
    return True if student_subject else False

async def user_liked_post(user_id: int, post_id: int) -> bool:
    like = await DataBaseManager().get_like(post_id, user_id)
    return True if like else False

async def warning_exists(warning_id: int) -> bool:
    warning = await DataBaseManager().get_warning_from_id(warning_id=warning_id)
    return True if warning else False

async def certification_exists(certification_id: int) -> bool:
    certification = await DataBaseManager().get_certification_from_id(certification_id)
    return True if certification else False