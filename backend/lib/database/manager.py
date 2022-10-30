from databases import Database
from sqlalchemy import create_engine, MetaData

from lib.database.models import DbModelsManager
from lib.singleton_handler import Singleton
from models.admins_models import Admin, AdminEdit, AdminIn, AdminOut
from models.majors_models import MajorEdit, MajorIn, MajorOut


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

