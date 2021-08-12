-- phpMyAdmin SQL Dump
-- version 4.8.5
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Waktu pembuatan: 12 Agu 2021 pada 15.36
-- Versi server: 10.1.38-MariaDB
-- Versi PHP: 7.3.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `trigger_table`
--

-- --------------------------------------------------------

--
-- Struktur dari tabel `log_harga_produk`
--

CREATE TABLE `log_harga_produk` (
  `id` int(11) NOT NULL,
  `kode_produk` varchar(6) NOT NULL,
  `harga_lama` int(11) NOT NULL,
  `harga_baru` int(11) NOT NULL,
  `waktu_perubahan` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data untuk tabel `log_harga_produk`
--

INSERT INTO `log_harga_produk` (`id`, `kode_produk`, `harga_lama`, `harga_baru`, `waktu_perubahan`) VALUES
(1, 'BR001', 120000, 90000, '2021-08-12 19:24:59');

-- --------------------------------------------------------

--
-- Struktur dari tabel `produk`
--

CREATE TABLE `produk` (
  `id` int(11) NOT NULL,
  `kode_produk` varchar(6) NOT NULL,
  `nama_produk` varchar(100) NOT NULL,
  `harga` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Trigger `produk`
--
DELIMITER $$
CREATE TRIGGER `before_produk_deleted` BEFORE DELETE ON `produk` FOR EACH ROW BEGIN
    INSERT INTO produk_bc 
    SET id=OLD.id, 
    kode_produk=OLD.kode_produk,
    nama_produk=OLD.nama_produk,
    harga=OLD.harga;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `before_produk_update` BEFORE UPDATE ON `produk` FOR EACH ROW BEGIN
    INSERT INTO log_harga_produk
    set kode_produk = OLD.kode_produk,
    harga_baru=new.harga,
    harga_lama=old.harga,
    waktu_perubahan = NOW(); 
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Struktur dari tabel `produk_bc`
--

CREATE TABLE `produk_bc` (
  `id_delete` int(11) NOT NULL,
  `id` int(11) NOT NULL,
  `kode_produk` varchar(6) NOT NULL,
  `nama_produk` varchar(100) NOT NULL,
  `harga` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data untuk tabel `produk_bc`
--

INSERT INTO `produk_bc` (`id_delete`, `id`, `kode_produk`, `nama_produk`, `harga`) VALUES
(4, 2, 'BR002', 'SEMINGGU JAGO PHP MYSQL', 80000),
(5, 1, 'BR001', 'SEMINGGU JAGO CODEIGNITER', 90000);

--
-- Indexes for dumped tables
--

--
-- Indeks untuk tabel `log_harga_produk`
--
ALTER TABLE `log_harga_produk`
  ADD PRIMARY KEY (`id`);

--
-- Indeks untuk tabel `produk`
--
ALTER TABLE `produk`
  ADD PRIMARY KEY (`id`);

--
-- Indeks untuk tabel `produk_bc`
--
ALTER TABLE `produk_bc`
  ADD PRIMARY KEY (`id_delete`);

--
-- AUTO_INCREMENT untuk tabel yang dibuang
--

--
-- AUTO_INCREMENT untuk tabel `log_harga_produk`
--
ALTER TABLE `log_harga_produk`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT untuk tabel `produk`
--
ALTER TABLE `produk`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT untuk tabel `produk_bc`
--
ALTER TABLE `produk_bc`
  MODIFY `id_delete` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
