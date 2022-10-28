from lib.database.manager import DataBaseManager

async def major_exists(id_or_name: int | str) -> bool:
    major = await DataBaseManager().get_major(id_or_name)
    return True if major else False
