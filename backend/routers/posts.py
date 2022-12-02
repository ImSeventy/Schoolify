from fastapi import APIRouter, status, Depends
from constants.enums import Roles
from lib.database.manager import DataBaseManager
from lib.exceptions.auth import InvalidCredentials
from models.posts_models import PostIn, PostOut, PostEdit
from models.likes_models import LikeIn, LikeOut
from lib.authentication.authentication import oauth2_scheme, get_user
from lib.exceptions.posts import PostNotFound, LikeNotFound
from lib.checks.checks import post_exists, like_exists

posts = APIRouter(prefix="/posts", tags=["posts"])


@posts.post("/", response_model=PostOut, status_code=status.HTTP_201_CREATED)
async def add_post(post: PostIn, token: str = Depends(oauth2_scheme)):
    admin = await get_user("admin", token=token)
    if admin.role != Roles.manager.value:
        raise InvalidCredentials()

    post.by = admin.id
    id = await DataBaseManager().add_new_post(post)
    return {**post.dict(), "id": id}


@posts.get("/{id}", response_model=PostOut, status_code=status.HTTP_200_OK)
async def get_post(id: int, token: str = Depends(oauth2_scheme)):
    _ = await get_user("admin", "student", token=token)

    if not await post_exists(id):
        raise PostNotFound()

    return await DataBaseManager().get_post_from_id(id)

@posts.get("/feed", response_model=list[PostOut], status_code=status.HTTP_200_OK)
async def get_feed_posts(token: str = Depends(oauth2_scheme)):
    _ = await get_user("admin", "student", token=token)
    
    return await DataBaseManager().get_all_posts()

@posts.delete("/{id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_post(id: int, token: str = Depends(oauth2_scheme)):
    admin = await get_user("admin", token=token)
    if admin.role != Roles.manager.value:
        raise InvalidCredentials()

    if not await post_exists(id):
        raise PostNotFound()

    await DataBaseManager().delete_post_with_id(id)


@posts.put("/{id}", status_code=status.HTTP_204_NO_CONTENT)
async def edit_post(id: int, post: PostEdit, token: str = Depends(oauth2_scheme)):
    admin = await get_user("admin", token=token)
    if admin.role != Roles.manager.value:
        raise InvalidCredentials()

    if not await post_exists(id):
        raise PostNotFound()

    await DataBaseManager().edit_post(id, post)

@posts.post("/{id}", response_model=LikeOut, status_code=status.HTTP_201_CREATED)
async def like_post(post_id : int, like: LikeIn, token: str = Depends(oauth2_scheme)):
    user = await get_user("admin", "student", token=token)
    
    if not await post_exists(post_id):
        raise PostNotFound()
    
    like.by = user.id
    like.post_id = post_id
    id = await DataBaseManager().add_new_like(like)
    return {**like.dict(), "id": id}

@posts.delete("/like/{id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_like(like_id: int, token: str = Depends(oauth2_scheme)):
    user = await get_user("admin", "student", token=token)
    
    author_id = await DataBaseManager().get_user_id_from_like_id(like_id)

    if user.id != author_id:
        raise LikeNotFound()
    
    if not await like_exists(like_id):
        raise LikeNotFound()
    
    await DataBaseManager().delete_like_with_id(like_id)