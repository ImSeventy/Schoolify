from fastapi import HTTPException, status

class PostNotFound(HTTPException):
    def __init__(self):
        super().__init__(
            status.HTTP_404_NOT_FOUND,
            "Post not found"
        )


class LikeNotFound(HTTPException):
    def __init__(self):
        super().__init__(
            status.HTTP_404_NOT_FOUND,
            "Like not found"
        )


class UserAlreadyLikedPost(HTTPException):
    def __init__(self):
        super().__init__(
            status.HTTP_409_CONFLICT,
            "User already liked the post"
        )


class UserDidnotLikePost(HTTPException):
    def __init__(self):
        super().__init__(
            status.HTTP_409_CONFLICT,
            "User did not like the post"
        )


class InvalidImageFormat(HTTPException):
    def __init__(self):
        super().__init__(
            status.HTTP_400_BAD_REQUEST,
            "Invalid image format"
        )


class ImageNotFound(HTTPException):
    def __init__(self):
        super().__init__(
            status.HTTP_404_NOT_FOUND,
            "Image not found"
        )