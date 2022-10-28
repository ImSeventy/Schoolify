from fastapi import HTTPException, status

class MajorNotFound(HTTPException):
    def __init__(self):
        super().__init__(status.HTTP_404_NOT_FOUND, "Major isn't found")