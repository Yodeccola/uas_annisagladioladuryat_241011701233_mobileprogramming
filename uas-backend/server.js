const express = require('express');
const cors = require('cors');
const app = express();
const PORT = 3000;

app.use(cors());
app.use(express.json());

// Data tiruan awal dengan struktur lengkap (Sampul pakai URL gambar publik)
let dataBuku = [
    { 
        id: 1, 
        judul: "Bumi Manusia", 
        penulis: "Pramoedya Ananta Toer", 
        genre: "Fiksi",
        sinopsis: "Kisah perjuangan Minke di era kolonial Belanda dan cintanya pada Annelies.",
        coverUrl: "https://images-na.ssl-images-amazon.com/images/S/compressed.photo.goodreads.com/books/1565658920i/1359430.jpg"
    },
    { 
        id: 2, 
        judul: "Filosofi Teras", 
        penulis: "Henry Manampiring", 
        genre: "Self Dev",
        sinopsis: "Panduan filsafat Stoisisme kuno untuk mengatasi kekhawatiran mental generasi masa kini.",
        coverUrl: "https://images-na.ssl-images-amazon.com/images/S/compressed.photo.goodreads.com/books/1544337222i/43123512.jpg"
    }
];

// GET ALL
app.get('/api/buku', (req, res) => {
    res.json(dataBuku);
});

// CREATE
app.post('/api/buku', (req, res) => {
    const newBuku = {
        id: Date.now(),
        judul: req.body.judul,
        penulis: req.body.penulis,
        genre: req.body.genre,
        sinopsis: req.body.sinopsis,
        coverUrl: req.body.coverUrl || "https://via.placeholder.com/150"
    };
    dataBuku.push(newBuku);
    res.status(201).json(newBuku);
});

// UPDATE
app.put('/api/buku/:id', (req, res) => {
    const id = parseInt(req.params.id);
    const index = dataBuku.findIndex(item => item.id === id);
    if (index !== -1) {
        dataBuku[index].judul = req.body.judul;
        dataBuku[index].penulis = req.body.penulis;
        dataBuku[index].genre = req.body.genre;
        dataBuku[index].sinopsis = req.body.sinopsis;
        dataBuku[index].coverUrl = req.body.coverUrl;
        res.json(dataBuku[index]);
    } else {
        res.status(404).json({ message: "Buku tidak ditemukan" });
    }
});

// DELETE
app.delete('/api/buku/:id', (req, res) => {
    const id = parseInt(req.params.id);
    dataBuku = dataBuku.filter(item => item.id !== id);
    res.json({ message: "Buku berhasil dihapus" });
});

app.listen(PORT, '0.0.0.0', () => {
    console.log(`Server Goodreads aktif di port ${PORT}`);
});