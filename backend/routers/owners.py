from fastapi import APIRouter, status, Depends
from fastapi.security import OAuth2PasswordRequestForm
from lib.database.manager import DataBaseManager
from lib.exceptions.owners import WrongPassowrdOrEmail
from lib.authentication.authentication import Authentication, oauth2_scheme, get_user
from models.owners_models import Owner, OwnerOut

owners = APIRouter(prefix="/owners", tags=["owners"])

@owners.post("/login", status_code=status.HTTP_200_OK)
async def login_owner(credintials: OAuth2PasswordRequestForm = Depends()):
    owner = await DataBaseManager().get_owner(credintials.username)
    if owner is None:
        raise WrongPassowrdOrEmail()

    if not Authentication.verify_password(credintials.password, owner.password):
        raise WrongPassowrdOrEmail()

    data = {
        "id": owner.id,
        "role": "owner",
    }

    return {
        "access_token": Authentication().create_access_token(data),
        "refresh_token": Authentication().create_refresh_token(data),
        "token_type": "bearer"
        }

@owners.get("/me", response_model=OwnerOut, status_code=status.HTTP_200_OK)
async def get_owner(token: str = Depends(oauth2_scheme)):
    return await get_user("owner", token=token)
