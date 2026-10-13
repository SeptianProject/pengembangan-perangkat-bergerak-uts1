-- CREATE TABLE peminjaman_novel
CREATE TABLE peminjaman_novel
(idPeminjaman INT AUTO_INCREMENT PRIMARY KEY,
idNovel SMALLINT UNSIGNED NOT NULL,
namaPeminjam VARCHAR(50) NOT NULL,
tglPinjam DATE NOT NULL,
statusPinjam ENUM('Dipinjam', 'Dikembalikan') DEFAULT 'Dipinjam',
CONSTRAINT fk_peminjaman_novel FOREIGN KEY (idNovel)
REFERENCES novel(idNovel) ON DELETE CASCADE ON UPDATE CASCADE)
ENGINE=INNODB;

-- TRANSAKSI PEMINJAMAN NOVEL
START TRANSACTION; 
INSERT INTO novel VALUES 
(NULL, 'Twilight', 'Stephanie Meyer'), 
(NULL, 'New Moon', 'Stephanie Meyer'); 
COMMIT; 
SELECT * FROM novel;

-- TRANSAKSI PEMINJAMAN NOVEL
START TRANSACTION; 
INSERT INTO novel VALUES 
(NULL, 'Eclipse', 'Stephanie Meyer'), 
(NULL, 'Breaking Down', 'Stephanie Meyer'); 
SELECT * FROM novel;
ROLLBACK;
SELECT * FROM novel;

-- Uji Titik Simpan dengan** **SAVEPOINT** **&amp;** **ROLLBACK TO SAVEPOINT**[10]
START TRANSACTION; INSERT INTO novel VALUES (NULL, 'Edensor', 'Andrea Hirata'); SAVEPOINT sp1; 

-- Skenario 1
START TRANSACTION; 
INSERT INTO novel VALUES (NULL, 'Bumi Manusia', 'Pramoedya Ananta Toer'); 
SET @id_bumi = LAST_INSERT_ID(); 
INSERT INTO peminjaman_novel VALUES (NULL, @id_bumi, 'Septian Asropik', '2026-10-12', 'Dipinjam'); 
SAVEPOINT sp_pinjam;
UPDATE peminjaman_novel SET statusPinjam = 'Dikembalikan' WHERE idNovel = @id_bumi;
ROLLBACK TO SAVEPOINT sp_pinjam; COMMIT;

-- Skenario 2
START TRANSACTION; 
UPDATE novel SET pengarangNovel = 'Pramoedya A. Toer' WHERE judulNovel = 'Bumi Manusia'; 
DELETE FROM peminjaman_novel WHERE namaPeminjam = 'Septian Asropik'; 
ROLLBACK;

-- Skenario 3
START TRANSACTION; 
INSERT INTO novel VALUES (NULL, 'Anak Semua Bangsa', 'Pramoedya Ananta Toer'); 
INSERT INTO peminjaman_novel VALUES (NULL, LAST_INSERT_ID(), 'Ahmad', '2026-10-12', 'Dipinjam'); 

-- Lock tabel
LOCK TABLE novel READ; 
SELECT * FROM novel;
INSERT INTO novel VALUES (NULL, 'Laskar Pelangi', 'Andrea Hirata');
UPDATE novel SET pengarangNovel = 'Stephanie M.' WHERE idNovel = 1;
DELETE FROM novel WHERE idNovel = 1;
SELECT * FROM peminjaman_novel;

-- Unlock tabel
UNLOCK TABLES;
INSERT INTO novel VALUES (NULL, 'Laskar Pelangi', 'Andrea Hirata');