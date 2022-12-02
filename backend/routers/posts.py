from fastapi import APIRouter, status, Depends
from lib.database.manager import DataBaseManager
from models.posts_models import PostIn, PostOut, PostEdit
from lib.authentication.authentication import oauth2_scheme, get_user
from lib.exceptions.posts import PostNotFound
from lib.checks.checks import post_exists

posts = APIRouter(
    prefix="/posts",
    tags=["posts"]
)

@posts.post("/", response_model=PostOut, status_code=status.HTTP_201_CREATED)
async def add_post(post: PostIn, token: str = Depends(oauth2_scheme)):
    manager = get_user("manager", token=token)
    id = await DataBaseManager().add_new_post(post)
    return {**post.dict(), "id": id}

@posts.get("/{id}", response_model=PostOut, status_code=status.HTTP_200_OK)
async def get_post(id: int, token: str = Depends(oauth2_scheme)):
    _ = await get_user("admin", "student", token=token)
    
    if not post_exists(id):
        raise PostNotFound()
    
    return await DataBaseManager().get_post_from_id(id)

@posts.delete("/{id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_post(id: int, token: str = Depends(oauth2_scheme)):
    manager = get_user("manager", token=token)
    
    if not post_exists(id):
        raise PostNotFound()
    
    await DataBaseManager().delete_post_with_id(id)

@posts.put("/{id}", response_model=PostOut, status_code=status.HTTP_200_OK)
async def edit_post(id: int, post: PostEdit, token: str = Depends(oauth2_scheme)):
    manager = get_user("manager", token=token)
    
    if not post_exists(id):
        raise PostNotFound()
    
    await DataBaseManager().edit_post(id)
    
    return {**post.dict(), "id": id}