from fastapi import APIRouter, status, Depends
from fastapi.responses import FileResponse
from constants.enums import ImagesSubPaths, Roles
from lib.database.manager import DataBaseManager
from lib.exceptions.auth import InvalidCredentials
from lib.images_manager.images_manager import ImagesManager
from models.posts_models import PostFormModel, PostOut, PostEdit
from models.likes_models import LikeOut
from lib.authentication.authentication import oauth2_scheme, get_user
from lib.exceptions.posts import ImageNotFound, InvalidImageFormat, PostNotFound, UserAlreadyLikedPost, UserDidnotLikePost
from lib.checks.checks import post_exists, user_liked_post

posts = APIRouter(prefix="/posts", tags=["posts"])


@posts.post("/", response_model=PostOut, status_code=status.HTTP_201_CREATED)
async def add_post(post: PostFormModel = Depends(), token: str = Depends(oauth2_scheme)):
    admin = await get_user("admin", token=token)
    if admin.role != Roles.manager.value:
        raise InvalidCredentials()

    post.by = admin.id
    if post.image is not None:
        if not ImagesManager().is_valid_image(post.image):
            raise InvalidImageFormat()

        image_url = ImagesManager().save_image(post.image, ImagesSubPaths.posts.value)
        post.image_url = image_url

    id = await DataBaseManager().add_new_post(post)
    return {**post.as_dict(), "id": id}

@posts.get("/image/{image_name}")
async def get_image(image_name: str):
    if not ImagesManager().image_exists(image_name, ImagesSubPaths.posts.value):
        raise ImageNotFound()

    return FileResponse(ImagesManager().get_image_path(image_name, ImagesSubPaths.posts.value))

@posts.get("/feed", response_model=list[PostOut], status_code=status.HTTP_200_OK)
async def get_feed_posts(token: str = Depends(oauth2_scheme)):
    _ = await get_user("admin", "student", token=token)
    
    return await DataBaseManager().get_all_posts()

@posts.get("/{id}", response_model=PostOut, status_code=status.HTTP_200_OK)
async def get_post(id: int, token: str = Depends(oauth2_scheme)):
    _ = await get_user("admin", "student", token=token)

    post = await DataBaseManager().get_post_from_id(id)
    if post is None:
        raise PostNotFound()

    return post

@posts.delete("/like", status_code=status.HTTP_204_NO_CONTENT)
async def delete_like(post_id: int, token: str = Depends(oauth2_scheme)):
    user = await get_user("admin", "student", token=token)
    
    post = await DataBaseManager().get_post_from_id(post_id)
    if post is None:
        raise PostNotFound()

    if not await user_liked_post(user.id, post_id):
        raise UserDidnotLikePost()
    
    await DataBaseManager().delete_like(post.id, user.id)

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

@posts.post("/like", response_model=LikeOut, status_code=status.HTTP_201_CREATED)
async def like_post(post_id : int, token: str = Depends(oauth2_scheme)):
    user = await get_user("admin", "student", token=token)
    
    post = await DataBaseManager().get_post_from_id(post_id)
    if post is None:
        raise PostNotFound()

    if await user_liked_post(user.id, post_id):
        raise UserAlreadyLikedPost()

    id = await DataBaseManager().add_new_like(by=user.id, post_id=post_id)
    return {"by": user.id, "id": id, "post_id": post_id}