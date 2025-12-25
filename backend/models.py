from sqlalchemy import Column, Integer, String
from database import Base

class Person(Base):
    __tablename__ = "persons"
    
    id = Column(Integer, primary_key=True, index=True)
    nom = Column(String, index=True)
    prenom = Column(String, index=True)
    telephone = Column(String, unique=True, index=True)

# Modèles Pydantic pour la validation
from pydantic import BaseModel

class PersonCreate(BaseModel):
    nom: str
    prenom: str
    telephone: str

class PersonResponse(BaseModel):
    id: int
    nom: str
    prenom: str
    telephone: str
    
    class Config:
        from_attributes = True
