# trigger_table

- Buat Database
```
make database trigger_table
```

- Buat Table `produk`
```sql
CREATE TABLE `produk` (
  `id` int(11) NOT NULL,
  `kode_produk` varchar(6) NOT NULL,
  `nama_produk` varchar(100) NOT NULL,
  `harga` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
ALTER TABLE `produk` ADD PRIMARY KEY (`id`);
ALTER TABLE `produk` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

INSERT INTO `produk` (`id`, `kode_produk`, `nama_produk`, `harga`) VALUES
(1, 'BR001', 'SEMINGGU JAGO CODEIGNITER', 90000),
(2, 'BR002', 'SEMINGGU JAGO PHP MYSQL', 80000);
```

- Buat Table `log_harga_produk`
```sql
CREATE TABLE `log_harga_produk` (
  `id` int(11) NOT NULL,
  `kode_produk` varchar(6) NOT NULL,
  `harga_lama` int(11) NOT NULL,
  `harga_baru` int(11) NOT NULL,
  `waktu_perubahan` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
ALTER TABLE `log_harga_produk` ADD PRIMARY KEY (`id`);
ALTER TABLE `log_harga_produk` MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;
```

- Buat Trigger `before_produk_update`
```sql
DELIMITER $$
CREATE TRIGGER `before_produk_update` 
BEFORE UPDATE ON `produk` 
FOR EACH ROW 
BEGIN
    INSERT INTO log_harga_produk
    set kode_produk = OLD.kode_produk,
    harga_baru=new.harga,
    harga_lama=old.harga,
    waktu_perubahan = NOW(); 
END
$$
DELIMITER ;
```
- Macam-macam Trigger
  - BEFORE INSERT – dijalankan ketika data di masukan ke dalam table.
  - AFTER INSERT – dijalankan setelah data masuk ke dalam table.
  - BEFORE UPDATE – dijalankan sebelum proses update data.
  - AFTER UPDATE – dijalankan setelah proses proses update data.
  - BEFORE DELETE – dijalankan sebelum proses delete data.
  - AFTER DELETE – dijalankan setelah proses delete data.

- Coba Trigger
```sql
update produk set harga=90000 WHERE kode_produk='BR001';
```
```sql
select * from log_harga_produk;
```

- Cara Menampilkan List Trigger
```sql
SHOW TRIGGERS;
```

- Cara Menghapus Trigger
```sql
DROP TRIGGER nama_trigger ;
//contoh implementasinya
DROP TRIGGER before_produk_update ;
```

- Test Dengan Delete
```sql
CREATE TABLE `produk_bc` (
  `id_delete` int(11) NOT NULL,
  `id` int(11) NOT NULL,
  `kode_produk` varchar(6) NOT NULL,
  `nama_produk` varchar(100) NOT NULL,
  `harga` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
ALTER TABLE `produk_bc`
  ADD PRIMARY KEY (`id_delete`);
ALTER TABLE `produk_bc`
  MODIFY `id_delete` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;
```
```sql
DELIMITER $$
CREATE TRIGGER after_produk_deleted 
    AFTER DELETE ON produk
    FOR EACH ROW 
BEGIN
    INSERT INTO produk_bc 
    SET id=OLD.id, 
    kode_produk=OLD.kode_produk,
    nama_produk=OLD.nama_produk,
    harga=OLD.harga;
END$$
DELIMITER ;
```

---

```
Copyright 2021 M. Fadli Zein
```