from sqlalchemy import Column, Integer, String
from pydantic import BaseModel, field_validator
from database import Base

# SQLAlchemy Models
class Person(Base):
    """Database model for contacts"""
    __tablename__ = "persons"
    
    id = Column(Integer, primary_key=True, index=True)
    nom = Column(String(100), nullable=False, index=True)
    prenom = Column(String(100), nullable=False, index=True)
    telephone = Column(String(20), unique=True, nullable=False, index=True)

class User(Base):
    """Database model for users"""
    __tablename__ = "users"
    
    id = Column(Integer, primary_key=True, index=True)
    username = Column(String(50), unique=True, nullable=False, index=True)
    password = Column(String(255), nullable=False)
    email = Column(String(100), unique=True, nullable=False, index=True)

# Pydantic Models for validation
class PersonCreate(BaseModel):
    """Schema for creating a new contact"""
    nom: str
    prenom: str
    telephone: str
    
    @field_validator('nom', 'prenom')
    @classmethod
    def validate_name(cls, v: str) -> str:
        if len(v.strip()) < 2:
            raise ValueError('Name must be at least 2 characters')
        return v.strip()
    
    @field_validator('telephone')
    @classmethod
    def validate_phone(cls, v: str) -> str:
        if len(v.strip()) < 10:
            raise ValueError('Phone number must be at least 10 digits')
        return v.strip()

class PersonResponse(BaseModel):
    """Schema for contact response"""
    id: int
    nom: str
    prenom: str
    telephone: str
    
    class Config:
        from_attributes = True

class UserCreate(BaseModel):
    """Schema for user registration"""
    username: str
    password: str
    email: str
    
    @field_validator('username')
    @classmethod
    def validate_username(cls, v: str) -> str:
        if len(v) < 3:
            raise ValueError('Username must be at least 3 characters')
        return v.strip()
    
    @field_validator('password')
    @classmethod
    def validate_password(cls, v: str) -> str:
        if len(v) < 6:
            raise ValueError('Password must be at least 6 characters')
        return v

class UserLogin(BaseModel):
    """Schema for user login"""
    username: str
    password: str

class UserResponse(BaseModel):
    """Schema for user response"""
    id: int
    username: str
    email: str
    
    class Config:
        from_attributes = True

class LoginResponse(BaseModel):
    """Schema for login response"""
    message: str
    user: UserResponse
