require 'pry'
require_relative "../config/environment.rb"

class Student
  attr_accessor :id, :name, :grade
  def initialize(id=nil, name, grade)
    @id = id
    @name = name
    @grade = grade
  end

  def self.create_table
    sql = <<-SQL
            CREATE TABLE students (
              id INTEGER PRIMARY KEY,
              name TEXT,
              grade INTEGER
            );
            SQL
    DB[:conn].execute(sql)
  end

  def self.drop_table
    DB[:conn].execute("DROP TABLE students")
  end

  def update
    sql = <<-SQL
            UPDATE students
            SET name = ?,
            grade = ?
            WHERE id = ?
            SQL
    DB[:conn].execute(sql, self.name, self.grade, self.id)
  end

  def save
    if self.id
      self.update
    else
    sql = <<-SQL
            INSERT INTO students
            (name, grade) VALUES
            (?, ?)
            SQL

    DB[:conn].execute(sql, self.name, self.grade)
    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
  
    end
  end

  def self.create (name, grade)
    student = Student.new(name,grade)
    sql = <<-SQL
            INSERT INTO students
            (name, grade) 
            VALUES (?,?)
            SQL
    DB[:conn].execute(sql, name, grade)
  end

  def self.new_from_db(array_from_db)
    student = Student.new(array_from_db[0], array_from_db[1], array_from_db[2])
    student
  end

  def self.find_by_name(name)
    sql = <<-SQL
          SELECT *
          FROM students
          WHERE name = ?
          SQL
      
    row = DB[:conn].execute(sql, name).flatten
    Student.new(row[0], row[1], row[2])
    
  end
end
 # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]