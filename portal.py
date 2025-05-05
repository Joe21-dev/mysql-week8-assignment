from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
import mysql.connector

app = FastAPI()

# MySQL connection
db = mysql.connector.connect(
    host="localhost",
    user="root",
    password=" ",
    database="student_portal"
)
cursor = db.cursor(dictionary=True)

class Student(BaseModel):
    name: str
    email: str
    age: int

class Course(BaseModel):
    title: str
    student_id: int

# Student
@app.post("/students")
def create_student(student: Student):
    query = "INSERT INTO Students (name, email, age) VALUES (%s, %s, %s)"
    cursor.execute(query, (student.name, student.email, student.age))
    db.commit()
    return {"message": "Student added"}

@app.get("/students")
def get_students():
    cursor.execute("SELECT * FROM Students")
    return cursor.fetchall()

@app.put("/students/{student_id}")
def update_student(student_id: int, student: Student):
    cursor.execute(
        "UPDATE Students SET name=%s, email=%s, age=%s WHERE id=%s",
        (student.name, student.email, student.age, student_id)
    )
    db.commit()
    return {"message": "Student updated"}

@app.delete("/students/{student_id}")
def delete_student(student_id: int):
    cursor.execute("DELETE FROM Students WHERE id=%s", (student_id,))
    db.commit()
    return {"message": "Student deleted"}
