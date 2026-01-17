from fastapi import FastAPI, Depends, HTTPException, status
from fastapi.middleware.cors import CORSMiddleware
from sqlalchemy.orm import Session
from typing import List
import hashlib
import re

from database import engine, get_db
from models import Base, Person, User
from models import PersonCreate, PersonResponse, UserCreate, UserLogin, UserResponse, LoginResponse

# Create database tables
Base.metadata.create_all(bind=engine)

app = FastAPI(
    title="Contact Management API",
    description="REST API for managing contacts with user authentication",
    version="1.0.0"
)

# CORS configuration for Flutter web and mobile
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # In production, specify exact origins
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Utility functions
def hash_password(password: str) -> str:
    """Hash password using SHA-256"""
    return hashlib.sha256(password.encode()).hexdigest()

def validate_email(email: str) -> bool:
    """Validate email format"""
    pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'
    return re.match(pattern, email) is not None

def validate_phone(phone: str) -> bool:
    """Validate phone number (at least 10 digits)"""
    return len(re.sub(r'\D', '', phone)) >= 10

# Authentication endpoints
@app.post("/register", response_model=UserResponse, status_code=status.HTTP_201_CREATED)
def register(user: UserCreate, db: Session = Depends(get_db)):
    """Register a new user"""
    # Validate email format
    if not validate_email(user.email):
        raise HTTPException(status_code=400, detail="Invalid email format")
    
    # Validate password length
    if len(user.password) < 6:
        raise HTTPException(status_code=400, detail="Password must be at least 6 characters")
    
    # Check if username exists
    if db.query(User).filter(User.username == user.username).first():
        raise HTTPException(status_code=400, detail="Username already exists")
    
    # Check if email exists
    if db.query(User).filter(User.email == user.email).first():
        raise HTTPException(status_code=400, detail="Email already exists")
    
    # Create new user
    db_user = User(
        username=user.username,
        password=hash_password(user.password),
        email=user.email
    )
    db.add(db_user)
    db.commit()
    db.refresh(db_user)
    return db_user

@app.post("/login", response_model=LoginResponse)
def login(credentials: UserLogin, db: Session = Depends(get_db)):
    """Authenticate user"""
    db_user = db.query(User).filter(User.username == credentials.username).first()
    
    if not db_user or db_user.password != hash_password(credentials.password):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid username or password"
        )
    
    return {"message": "Login successful", "user": db_user}

# Contact endpoints
@app.post("/personnes", response_model=PersonResponse, status_code=status.HTTP_201_CREATED)
def create_person(person: PersonCreate, db: Session = Depends(get_db)):
    """Create a new contact"""
    # Validate phone number
    if not validate_phone(person.telephone):
        raise HTTPException(status_code=400, detail="Phone number must be at least 10 digits")
    
    # Validate names
    if len(person.nom.strip()) < 2 or len(person.prenom.strip()) < 2:
        raise HTTPException(status_code=400, detail="Names must be at least 2 characters")
    
    # Check if phone already exists
    if db.query(Person).filter(Person.telephone == person.telephone).first():
        raise HTTPException(status_code=400, detail="This phone number already exists")
    
    db_person = Person(
        nom=person.nom.strip(),
        prenom=person.prenom.strip(),
        telephone=person.telephone.strip()
    )
    db.add(db_person)
    db.commit()
    db.refresh(db_person)
    return db_person

@app.get("/personnes", response_model=List[PersonResponse])
def get_persons(skip: int = 0, limit: int = 100, db: Session = Depends(get_db)):
    """Get all contacts with pagination"""
    persons = db.query(Person).offset(skip).limit(limit).all()
    return persons

@app.get("/personnes/{person_id}", response_model=PersonResponse)
def get_person(person_id: int, db: Session = Depends(get_db)):
    """Get a specific contact by ID"""
    person = db.query(Person).filter(Person.id == person_id).first()
    if not person:
        raise HTTPException(status_code=404, detail="Contact not found")
    return person

@app.put("/personnes/{person_id}", response_model=PersonResponse)
def update_person(person_id: int, person: PersonCreate, db: Session = Depends(get_db)):
    """Update a contact"""
    # Validate phone number
    if not validate_phone(person.telephone):
        raise HTTPException(status_code=400, detail="Phone number must be at least 10 digits")
    
    # Validate names
    if len(person.nom.strip()) < 2 or len(person.prenom.strip()) < 2:
        raise HTTPException(status_code=400, detail="Names must be at least 2 characters")
    
    # Get existing person
    db_person = db.query(Person).filter(Person.id == person_id).first()
    if not db_person:
        raise HTTPException(status_code=404, detail="Contact not found")
    
    # Check if phone already exists for another contact
    existing_phone = db.query(Person).filter(
        Person.telephone == person.telephone,
        Person.id != person_id
    ).first()
    if existing_phone:
        raise HTTPException(status_code=400, detail="This phone number already exists")
    
    # Update person
    db_person.nom = person.nom.strip()
    db_person.prenom = person.prenom.strip()
    db_person.telephone = person.telephone.strip()
    
    db.commit()
    db.refresh(db_person)
    return db_person

@app.delete("/personnes/{person_id}")
def delete_person(person_id: int, db: Session = Depends(get_db)):
    """Delete a contact"""
    person = db.query(Person).filter(Person.id == person_id).first()
    if not person:
        raise HTTPException(status_code=404, detail="Contact not found")
    
    db.delete(person)
    db.commit()
    return {"message": "Contact deleted successfully"}

@app.get("/")
def root():
    """API health check"""
    return {"status": "ok", "message": "Contact Management API is running"}

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="127.0.0.1", port=8000)
