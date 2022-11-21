from datetime import datetime, timedelta
from passlib.context import CryptContext
from fastapi import Depends
from fastapi.security import OAuth2PasswordBearer
from jose import JWTError, jwt
from lib.authentication.fetching_users_manager import FetchingUsersManager
from lib.singleton_handler import Singleton
from lib.exceptions.auth import InvalidCredentials
from constants.enums import TokenTypes


pwd_context = CryptContext(["bcrypt"], deprecated="auto")
oauth2_scheme = OAuth2PasswordBearer(tokenUrl="token")

class Authentication(metaclass=Singleton):
    def __init__(
        self,
        access_token_secret_key: str,
        refresh_token_secret_key: str,
        algorithm: str,
        access_token_expire_mins: int,
        refresh_token_expire_days: int
        ) -> None:
        self.access_token_secret_key = access_token_secret_key
        self.refresh_token_secret_key = refresh_token_secret_key
        self.algorithm = algorithm
        self.access_token_expire_mins = access_token_expire_mins
        self.refresh_token_expire_days = refresh_token_expire_days

    @staticmethod
    def verify_password(to_verify: str, password: str) -> bool:
        return pwd_context.verify(to_verify, password)

    @staticmethod
    def hash_password(password: str) -> str:
        return pwd_context.hash(password)

    def create_access_token(self, data: dict) -> str:
        to_encode = data.copy()
        expire_time = datetime.now() + timedelta(minutes=self.access_token_expire_mins)
        to_encode["exp"] = expire_time.timestamp()
        return jwt.encode(to_encode, self.access_token_secret_key, algorithm=self.algorithm)

    def create_refresh_token(self, data: dict) -> str:
        to_encode = data.copy()
        expire_time = datetime.now() + timedelta(days=self.refresh_token_expire_days)
        to_encode["exp"] = expire_time.timestamp()
        return jwt.encode(to_encode, self.refresh_token_secret_key, algorithm=self.algorithm)

    def refresh_access_token(self, refresh_token: str) -> str:
        payload = self.get_token_data(refresh_token, TokenTypes.REFRESH_TOKEN)
        access_token = self.create_access_token(payload)
        new_refresh_token = self.create_refresh_token(payload)
        return access_token, new_refresh_token

    def get_token_data(self, token: str, type: TokenTypes) -> dict:
        secret_key = self.access_token_secret_key if type == TokenTypes.ACCESS_TOKEN else self.refresh_token_secret_key
        try:
            payload = jwt.decode(token, secret_key, algorithms=[self.algorithm])
            id = payload.get("id")
            if id is None:
                raise InvalidCredentials()
        except JWTError:
            raise InvalidCredentials()

        return payload


async def get_user(role: str, token: str = Depends(oauth2_scheme)):
    token_data = Authentication().get_token_data(token, TokenTypes.ACCESS_TOKEN)
    return await FetchingUsersManager.fetch_user(role, token_data)

    