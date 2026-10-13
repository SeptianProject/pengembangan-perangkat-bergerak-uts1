CREATE DATABASE IF NOT EXISTS db_monitoring_ta; 
USE db_monitoring_ta;


CREATE TABLE dosen 
(id BIGINT AUTO_INCREMENT PRIMARY KEY, 
users_id BIGINT, 
nip VARCHAR(45) NOT NULL, 
nidn VARCHAR(45), 
name VARCHAR(255) NOT NULL, 
jenis_kelamin ENUM('L', 'P') DEFAULT 'L', 
telp VARCHAR(45)) ENGINE=INNODB;

CREATE TABLE mahasiswa 
(id BIGINT AUTO_INCREMENT PRIMARY KEY, 
users_id BIGINT, 
kelas VARCHAR(45), 
nim VARCHAR(45) NOT NULL UNIQUE, 
nama_mhs VARCHAR(255) NOT NULL, 
jenis_kelamin ENUM('L', 'P') DEFAULT 'L', 
telp VARCHAR(45)) ENGINE=INNODB;

CREATE TABLE jenis_ta 
(id BIGINT AUTO_INCREMENT PRIMARY KEY, 
nama_jenis VARCHAR(45) NOT NULL) ENGINE=INNODB;

CREATE TABLE topik 
(id BIGINT AUTO_INCREMENT PRIMARY KEY, 
nama_topik VARCHAR(45) NOT NULL) ENGINE=INNODB;

CREATE TABLE periode_ta 
(id BIGINT AUTO_INCREMENT PRIMARY KEY, 
mulai_daftar DATE, 
akhir_daftar DATE) ENGINE=INNODB;

CREATE TABLE tugas_akhir 
(id BIGINT AUTO_INCREMENT PRIMARY KEY,
jenis_ta_id BIGINT NOT NULL,
topik_id BIGINT NOT NULL,
mahasiswa_id BIGINT NOT NULL,
periode_ta_id BIGINT NOT NULL,
judul VARCHAR(255) NOT NULL,
tipe ENUM('K', 'I') DEFAULT 'K',
status ENUM('draft', 'acc', 'reject') DEFAULT 'draft', 
catatan TEXT, 
CONSTRAINT fk_ta_mhs FOREIGN KEY (mahasiswa_id) 
REFERENCES mahasiswa(id) ON DELETE CASCADE ON UPDATE CASCADE, 
CONSTRAINT fk_ta_jenis FOREIGN KEY (jenis_ta_id) 
REFERENCES jenis_ta(id), 
CONSTRAINT fk_ta_topik FOREIGN KEY (topik_id) 
REFERENCES topik(id)) ENGINE=INNODB;

CREATE TABLE bimbing_uji 
(id BIGINT AUTO_INCREMENT PRIMARY KEY, 
tugas_akhir_id BIGINT NOT NULL, 
dosen_id BIGINT NOT NULL, 
jenis ENUM('pemb_1', 'pemb_2', 'penguji_1', 'penguji_2') NOT NULL, 
urut INT DEFAULT 1, 
CONSTRAINT fk_bu_ta FOREIGN KEY (tugas_akhir_id) 
REFERENCES tugas_akhir(id) ON DELETE CASCADE, 
CONSTRAINT fk_bu_dosen FOREIGN KEY (dosen_id) 
REFERENCES dosen(id)) ENGINE=INNODB;

INSERT INTO jenis_ta VALUES 
(1, 'Rancang Bangun/Prototype'), 
(2, 'Penelitian/Pengabdian'); 

INSERT INTO topik VALUES 
(1, 'Usulan Topik Baru'), 
(2, 'Lanjutan MBKM'); 

INSERT INTO periode_ta VALUES 
(1, '2026-02-01', '2026-07-31'); 

INSERT INTO dosen VALUES 
(1, 101, '198310202014042001', '0722018301', 'Eka Mistiko Rini, S.Kom., M.Kom.', 'P', '081013922224'), 
(2, 102, '198403052021212004', '0705038402', 'Dianni Yusuf, S.Kom., M.Kom.', 'P', '082328333399'); 
INSERT INTO mahasiswa VALUES 
(1, 201, '4A', '362558302064', 'Septian Asropik', 'L', '085239019283'), 
(2, 202, '4A', '362055401029', 'Putri Novitasari', 'P', '085748614391');

-- Uji commit
START TRANSACTION; 
INSERT INTO jenis_ta VALUES (3, 'Pengembangan Sistem Website'); 
COMMIT; 
SELECT * FROM jenis_ta;

-- Uji rollback
START TRANSACTION; 
INSERT INTO jenis_ta VALUES (4, 'Sistem Pakar AI'); 
SELECT * FROM jenis_ta;
ROLLBACK; 
SELECT * FROM jenis_ta;

-- Uji savepoint
START TRANSACTION; INSERT INTO topik VALUES (3, 'Topik Mandiri Mahasiswa'); 
SAVEPOINT sp_topik; 
INSERT INTO topik VALUES (4, 'Topik Industri Kerjasama'); 
ROLLBACK TO SAVEPOINT sp_topik; 
COMMIT; 
SELECT * FROM topik; 

-- Skenario 1:
USE db_monitoring_ta; 
START TRANSACTION;
INSERT INTO tugas_akhir (id, jenis_ta_id, topik_id, mahasiswa_id, periode_ta_id, judul, tipe, status, catatan) 
VALUES (101, 1, 1, 1, 1, 'Rancang Bangun Sistem Monitoring TA Berbasis Web', 'K', 'draft', 'Pengajuan awal Septian');
SAVEPOINT sp_pengajuan;
UPDATE tugas_akhir SET catatan = 'Revisi total proposal' WHERE id = 101;
ROLLBACK TO SAVEPOINT sp_pengajuan;
COMMIT;
SELECT id, judul, status, catatan FROM tugas_akhir WHERE id = 101;

-- Skenario 2
START TRANSACTION;
INSERT INTO bimbing_uji (id, tugas_akhir_id, dosen_id, jenis, urut) VALUES (201, 101, 1, 'pemb_1', 1);
UPDATE tugas_akhir SET status = 'acc' WHERE id = 101;
DELETE FROM bimbing_uji WHERE id = 201;
ROLLBACK;
SELECT status FROM tugas_akhir WHERE id = 101; 
SELECT * FROM bimbing_uji WHERE id = 201;

-- Skenario 3
START TRANSACTION;
INSERT INTO tugas_akhir (id, jenis_ta_id, topik_id, mahasiswa_id, periode_ta_id, judul, tipe, status) VALUES (102, 2, 2, 2, 1, 'Sistem Informasi Pengolahan Nilai Bimbingan TA', 'I', 'draft');
INSERT INTO bimbing_uji (id, tugas_akhir_id, dosen_id, jenis, urut) VALUES (202, 102, 2, 'pemb_1', 1);
USE db_monitoring_ta; 
SELECT * FROM tugas_akhir WHERE id = 102; 
SELECT * FROM bimbing_uji WHERE id = 202;

-- Lock
LOCK TABLE tugas_akhir READ;
SELECT id, judul, status FROM tugas_akhir;
INSERT INTO tugas_akhir VALUES (103, 1, 1, 1, 1, 'Uji Lock Insert', 'K', 'draft', '');
UPDATE tugas_akhir SET status = 'acc' WHERE id = 101;
DELETE FROM tugas_akhir WHERE id = 101;
SELECT * FROM mahasiswa;
UNLOCK TABLES;
