from pydantic import BaseSettings


class Settings(BaseSettings):
    access_token_secret_key: str
    refresh_token_secret_key: str
    algorithm: str
    access_token_expire_minutes: int
    refresh_token_expire_days: int
    first_semester_start_month: int
    first_semester_end_month: int
    second_semester_start_month: int
    second_semester_end_month: int
    images_path: str
    ip_address: str

    class Config:
        env_file = ".env"