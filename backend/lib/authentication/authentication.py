from passlib.context import CryptContext
from lib.singleton_handler import Singleton


pwd_context = CryptContext(["bcrypt"], deprecated="auto")


class Authentication(metaclass=Singleton):
    @staticmethod
    def verify_password(to_verify: str, password: str) -> bool:
        return pwd_context.verify(to_verify, password)

    @staticmethod
    def hash_password(password: str) -> str:
        return pwd_context.hash(password)