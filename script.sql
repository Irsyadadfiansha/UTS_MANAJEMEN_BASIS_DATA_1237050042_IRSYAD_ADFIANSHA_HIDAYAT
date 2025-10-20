-- membuat schema
CREATE SCHEMA IF NOT EXISTS SALAM;

-- membuat tabel mahasiswas dalam schema SALAM
CREATE TABLE SALAM.mahasiswas (
    nim CHAR(10) PRIMARY KEY,                     -- Primary key
    nama VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,                    -- Unique constraint
    umur INT CHECK (umur >= 17),                  -- Check constraint
    jurusan VARCHAR(50) DEFAULT 'Informatika'
);


-- uji constraint
-- INSSERT DATA VALID
INSERT INTO SALAM.mahasiswas (nim, nama, email, umur, jurusan)
VALUES ('2023000001', 'Irsyad', 'irsyad@example.com', 20, 'Informatika');
-- Berhasil — karena semua constraint terpenuhi.


-- Uji Primary Key (duplikat NIM)
INSERT INTO SALAM.mahasiswas (nim, nama, email, umur, jurusan)
VALUES ('2023000001', 'Ahmad', 'ahmad@example.com', 21, 'Sistem Informasi');
-- HASILNYA AKAN ERROR
-- ERROR:  duplicate key value violates unique constraint "mahasiswas_pkey"
-- DETAIL:  Key (nim)=(2023000001) already exists.

-- Uji Unique Constraint (duplikat email)
INSERT INTO SALAM.mahasiswas (nim, nama, email, umur, jurusan)
VALUES ('2023000002', 'Budi', 'irsyad@example.com', 19, 'Teknik Komputer');
-- Hasil error:
-- ERROR:  duplicate key value violates unique constraint "mahasiswas_email_key"
-- DETAIL:  Key (email)=(irsyad@example.com) already exists.


-- Uji Check Constraint (umur < 17)
INSERT INTO SALAM.mahasiswas (nim, nama, email, umur, jurusan)
VALUES ('2023000003', 'Citra', 'citra@example.com', 15, 'Informatika');
-- hasilnya akan error
-- ERROR:  new row for relation "mahasiswas" violates check constraint "mahasiswas_umur_check"
-- DETAIL:  Failing row contains (2023000003, Citra, citra@example.com, 15, Informatika).


-- Buat user
CREATE ROLE backend_dev LOGIN PASSWORD 'ifunggul';
CREATE ROLE bi_dev LOGIN PASSWORD 'ifunggul';
CREATE ROLE data_engineer LOGIN PASSWORD 'ifunggul';


-- backend_dev → CRUD (Create, Read, Update, Delete)
GRANT USAGE ON SCHEMA SALAM TO backend_dev;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA SALAM TO backend_dev;
ALTER DEFAULT PRIVILEGES IN SCHEMA SALAM
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO backend_dev;


-- bi_dev → Read-only (SELECT saja)
GRANT USAGE ON SCHEMA SALAM TO bi_dev;
GRANT SELECT ON ALL TABLES IN SCHEMA SALAM TO bi_dev;
ALTER DEFAULT PRIVILEGES IN SCHEMA SALAM
GRANT SELECT ON TABLES TO bi_dev;


-- data_engineer → Dapat membuat, mengubah, dan menghapus objek (tabel, view, dsb)
GRANT USAGE, CREATE ON SCHEMA SALAM TO data_engineer;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA SALAM TO data_engineer;
ALTER DEFAULT PRIVILEGES IN SCHEMA SALAM
GRANT ALL PRIVILEGES ON TABLES TO data_engineer;
GRANT CREATE, ALTER, DROP ON DATABASE salam_db TO data_engineer;


-- Uji backend_dev (CRUD boleh)
SET ROLE backend_dev;

-- SELECT boleh
SELECT * FROM SALAM.mahasiswas;

-- INSERT boleh
INSERT INTO SALAM.mahasiswas (nim, nama, email, umur)
VALUES ('2023000004', 'Andi', 'andi@example.com', 22);

-- UPDATE boleh
UPDATE SALAM.mahasiswas SET umur = 23 WHERE nim = '2023000004';

-- DELETE boleh
DELETE FROM SALAM.mahasiswas WHERE nim = '2023000004';


-- Uji bi_dev (read-only)
SET ROLE bi_dev;

-- SELECT boleh
SELECT * FROM SALAM.mahasiswas;

-- INSERT harus gagal
INSERT INTO SALAM.mahasiswas (nim, nama, email, umur)
VALUES ('2023000005', 'Budi', 'budi@example.com', 21);
-- isi error
-- ERROR:  permission denied for table mahasiswas


-- kembalikan error
RESET ROLE;


-- Uji data_engineer (CRUD + CREATE/MODIFY/DROP)
SET ROLE data_engineer;

-- CRUD
INSERT INTO SALAM.mahasiswas (nim, nama, email, umur)
VALUES ('2023000006', 'Citra', 'citra2@example.com', 22);

-- Membuat tabel baru
CREATE TABLE SALAM.log_aktivitas (
    id SERIAL PRIMARY KEY,
    aktivitas VARCHAR(255),
    waktu TIMESTAMP DEFAULT NOW()
);

-- Menghapus tabel
DROP TABLE SALAM.log_aktivitas;
