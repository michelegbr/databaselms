/*
=============================================================================
A. PENJELASAN DATABASE (ERD, PK, FK, KARDINALITAS) 
-----------------------------------------------------------------------------
1. Entitas: users
   - Primary Key (PK): user_id 
   - Fungsi: Menyimpan data pengguna (student/instructor).

2. Entitas: categories
   - Primary Key (PK): category_id 
   - Fungsi: Menyimpan kategori course.

3. Entitas: courses
   - Primary Key (PK): course_id 
   - Foreign Key (FK): instructor_id (merujuk ke users.user_id), category_id (merujuk ke categories.category_id)
   - Fungsi: Menyimpan data kelas.

4. Entitas: lessons
   - Primary Key (PK): lesson_id 
   - Foreign Key (FK): course_id (merujuk ke courses.course_id)
   - Fungsi: Menyimpan daftar materi dalam course.

5. Entitas: enrollments
   - Primary Key (PK): enrollment_id 
   - Foreign Key (FK): student_id (merujuk ke users.user_id), course_id (merujuk ke courses.course_id)
   - Fungsi: Menyimpan data pendaftaran & progres siswa.

B. RELATIONSHIP & CARDINALITY 
-----------------------------------------------------------------------------
- Users (Instructor) -> Courses: 1-to-Many (1 Instruktur bisa buat banyak course). 
- Categories -> Courses: 1-to-Many (1 Kategori punya banyak course). 
- Courses -> Lessons: 1-to-Many (1 Course punya banyak lesson). 
- Users (Student) <-> Courses: Many-to-Many, dipecah menggunakan tabel enrollments 
  menjadi dua relasi 1-to-Many (Users -> Enrollments dan Courses -> Enrollments). 
=============================================================================
*/

CREATE DATABASE database_lms;
USE database_lms;

CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    role ENUM('instructor', 'student') DEFAULT 'student',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL
);

CREATE TABLE courses (
    course_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    quota INT DEFAULT 0,
    instructor_id INT,
    category_id INT,
    FOREIGN KEY (instructor_id) REFERENCES users(user_id) ON DELETE SET NULL,
    FOREIGN KEY (category_id) REFERENCES categories(category_id) ON DELETE SET NULL
);

CREATE TABLE lessons (
    lesson_id INT AUTO_INCREMENT PRIMARY KEY,
    course_id INT,
    title VARCHAR(255) NOT NULL,
    video_url VARCHAR(255),
    FOREIGN KEY (course_id) REFERENCES courses(course_id) ON DELETE CASCADE
);

CREATE TABLE enrollments (
    enrollment_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT,
    course_id INT,
    progress_percent INT DEFAULT 0,
    enrolled_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (student_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (course_id) REFERENCES courses(course_id) ON DELETE CASCADE
);

-- Insert 10 Categories
INSERT INTO categories (category_name) VALUES 
('UI/UX Design'), ('Backend Development'), ('Frontend Development'), ('Mobile Programming'), 
('Computer Science Theory'), ('Data Science'), ('DevOps'), ('Cybersecurity'), 
('Database Management'), ('Artificial Intelligence');

-- Insert 15 Users
INSERT INTO users (name, email, role) VALUES 
('Alan Turing', 'alan@lms.com', 'instructor'), ('Grace Hopper', 'grace@lms.com', 'instructor'), 
('Ada Lovelace', 'ada@lms.com', 'instructor'), ('Linus Torvalds', 'linus@lms.com', 'instructor'), 
('Tim Berners-Lee', 'tim@lms.com', 'instructor'), ('Budi Santoso', 'budi@student.com', 'student'), 
('Siti Aminah', 'siti@student.com', 'student'), ('Andi Pratama', 'andi@student.com', 'student'), 
('Rina Wijaya', 'rina@student.com', 'student'), ('Joko Widodo', 'joko@student.com', 'student'),
('Dewi Lestari', 'dewi@student.com', 'student'), ('Eko Saputra', 'eko@student.com', 'student'),
('Fajar Nugroho', 'fajar@student.com', 'student'), ('Gita Gutawa', 'gita@student.com', 'student'),
('Hendra Gunawan', 'hendra@student.com', 'student');

-- Insert 15 Courses
INSERT INTO courses (title, price, quota, instructor_id, category_id) VALUES 
('Mastering UI/UX with Figma', 150000, 50, 1, 1), 
('Backend Dev with Node.js', 250000, 40, 2, 2), 
('Full-stack Web Dev using TypeScript', 550000, 30, 3, 3), 
('Tailwind CSS for Beginners', 75000, 100, 3, 3), 
('Mobile Programming with React Native', 180000, 60, 4, 4), 
('Algorithm and Programming Basics', 45000, 200, 1, 5), 
('Automata Theory and Parsing', 120000, 30, 1, 5), 
('Advanced UI/UX Interactive Design', 600000, 20, 1, 1), 
('Zero to Hero MySQL', 90000, 80, 2, 9), 
('Flutter Mobile Dev', 300000, 50, 4, 4), 
('Deep Dive into Next.js', 150000, 40, 3, 3), 
('Go Lang Backend Architecture', 400000, 25, 2, 2), 
('Introduction to DFA and NFA', 80000, 0, 1, 5), 
('HTML & CSS Mastery', 60000, 150, 5, 3), 
('DevOps Automation', 550000, 0, 4, 7); 

-- Insert 10 Lessons
INSERT INTO lessons (course_id, title, video_url) VALUES
(1, 'Pengenalan Figma', 'url/vid1'), (1, 'Wireframing', 'url/vid2'),
(3, 'Setup TypeScript', 'url/vid3'), (3, 'TS Interfaces', 'url/vid4'),
(4, 'Utility Classes Tailwind', 'url/vid5'), (4, 'Responsive Design Tailwind', 'url/vid6'),
(6, 'Apa itu Algoritma?', 'url/vid7'), (7, 'Konsep NFA', 'url/vid8'),
(9, 'DDL dan DML', 'url/vid9'), (14, 'Struktur HTML Dasar', 'url/vid10');

-- Insert 10 Enrollments
INSERT INTO enrollments (student_id, course_id, progress_percent) VALUES
(6, 1, 50), (6, 4, 100), (7, 3, 20), (8, 6, 80), (9, 7, 0),
(10, 9, 10), (11, 14, 100), (12, 1, 30), (13, 3, 45), (14, 4, 90);

-- Tampilkan seluruh data course 
SELECT * FROM courses;

-- Tampilkan nama course dan harga saja 
SELECT title, price FROM courses;

-- Tampilkan course dengan harga antara 50.000 sampai 200.000 
SELECT * FROM courses WHERE price BETWEEN 50000 AND 200000;

-- Tampilkan course yang memiliki kuota 0 ATAU harga di atas 500.000 
SELECT * FROM courses WHERE quota = 0 OR price > 500000;

-- Tampilkan 5 course dengan harga tertinggi
SELECT * FROM courses ORDER BY price DESC LIMIT 5;

-- Hitung total user yang terdaftar 
SELECT COUNT(*) AS total_users FROM users;

-- Hitung total course yang tersedia 
SELECT COUNT(*) AS total_courses FROM courses;

-- Hitung jumlah course per kategori 
SELECT category_id, COUNT(course_id) AS total_courses 
FROM courses GROUP BY category_id;

-- Hitung rata-rata harga course per kategori
SELECT category_id, AVG(price) AS average_price 
FROM courses GROUP BY category_id;

-- Tampilkan kategori yang memiliki lebih dari 3 course 
SELECT category_id, COUNT(course_id) AS total_courses 
FROM courses GROUP BY category_id HAVING COUNT(course_id) > 3;

-- Tampilkan daftar course beserta nama kategorinya 
SELECT c.title, cat.category_name 
FROM courses c
INNER JOIN categories cat ON c.category_id = cat.category_id;

-- Tampilkan semua kategori meskipun belum memiliki course 
SELECT cat.category_name, c.title 
FROM categories cat
LEFT JOIN courses c ON cat.category_id = c.category_id;

-- Tampilkan semua user meskipun belum pernah mengupload course 
SELECT u.name, c.title 
FROM users u
LEFT JOIN courses c ON u.user_id = c.instructor_id;

-- Tampilkan daftar course beserta nama instructor yang membuat course tersebut 
SELECT c.title, u.name AS instructor_name 
FROM courses c
INNER JOIN users u ON c.instructor_id = u.user_id;

-- Tampilkan jumlah course yang dibuat oleh masing-masing instructor 
SELECT u.name AS instructor_name, COUNT(c.course_id) AS total_courses_created
FROM users u
LEFT JOIN courses c ON u.user_id = c.instructor_id
WHERE u.role = 'instructor'
GROUP BY u.user_id;