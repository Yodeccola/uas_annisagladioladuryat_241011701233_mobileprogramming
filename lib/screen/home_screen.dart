import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_screen.dart';
import 'my_books_screen.dart'; // Import halaman baru
import 'quiz_screen.dart';      // Import halaman baru
import '../states/book_state.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentSubPageIndex = 0; // Indeks halaman aktif navbar atas
  final List<String> _genres = ['Fiksi', 'Romansa', 'Fantasi', 'Self Dev', 'Misteri'];

  // Fungsi merender halaman terpilih secara dinamis (Multi-Page System)
  Widget _buildBody() {
    switch (_currentSubPageIndex) {
      case 0:
        return _buildBrowsePage(); // Halaman list katalog utama
      case 1:
        return const MyBooksScreen(); // Halaman Rak & Review Anda
      case 2:
        return const QuizScreen(); // Halaman Kuis Rekomendasi
      default:
        return _buildBrowsePage();
    }
  }

  // Dialog Form Tambah / Edit Data (Menggunakan state global BookState)
  void _showFormDialog({
    int? id,
    String? currentJudul,
    String? currentPenulis,
    String? currentGenre,
    String? currentSinopsis,
    String? currentCover,
  }) {
    final judulController = TextEditingController(text: currentJudul);
    final penulisController = TextEditingController(text: currentPenulis);
    final sinopsisController = TextEditingController(text: currentSinopsis);
    final coverController = TextEditingController(text: currentCover);
    
    String selectedGenre = currentGenre ?? _genres[0];

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(
            id == null ? 'Tambah Buku Baru' : 'Edit Detail Buku',
            style: TextStyle(color: Colors.brown[900], fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: judulController,
                  decoration: const InputDecoration(labelText: 'Judul Buku', hintText: 'Masukkan judul'),
                ),
                TextField(
                  controller: penulisController,
                  decoration: const InputDecoration(labelText: 'Nama Penulis', hintText: 'Masukkan nama penulis'),
                ),
                TextField(
                  controller: coverController,
                  decoration: const InputDecoration(
                    labelText: 'Nama File Gambar Cover', 
                    hintText: 'Contoh: the_cruel_prince.jpg',
                  ),
                ),
                TextField(
                  controller: sinopsisController,
                  decoration: const InputDecoration(labelText: 'Sinopsis Buku', hintText: 'Tulis ringkasan cerita singkat'),
                  maxLines: 3,
                ),
                const SizedBox(height: 20),
                Text(
                  'Pilih Genre Buku:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.brown[700]),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _genres.map((genre) {
                    final isSelected = selectedGenre == genre;
                    return ChoiceChip(
                      label: Text(genre),
                      selected: isSelected,
                      selectedColor: Colors.brown[600],
                      backgroundColor: Colors.grey[200],
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : Colors.black87,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                      onSelected: (bool selected) {
                        if (selected) {
                          setDialogState(() {
                            selectedGenre = genre;
                          });
                        }
                      },
                    );
                  }).toList(),
                )
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Batal', style: TextStyle(color: Colors.grey[600])),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.brown[700],
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () {
                if (judulController.text.isEmpty || penulisController.text.isEmpty) return;

                setState(() {
                  if (id == null) {
                    // Operasi Tambah Data ke BookState
                    BookState.masterBooks.add({
                      'id': DateTime.now().millisecondsSinceEpoch,
                      'judul': judulController.text,
                      'penulis': penulisController.text,
                      'genre': selectedGenre,
                      'sinopsis': sinopsisController.text,
                      'coverUrl': coverController.text,
                    });
                  } else {
                    // Operasi Edit Data di BookState
                    final index = BookState.masterBooks.indexWhere((element) => element['id'] == id);
                    if (index != -1) {
                      BookState.masterBooks[index] = {
                        'id': id,
                        'judul': judulController.text,
                        'penulis': penulisController.text,
                        'genre': selectedGenre,
                        'sinopsis': sinopsisController.text,
                        'coverUrl': coverController.text,
                      };
                    }
                  }
                });

                Navigator.pop(context);
              },
              child: const Text('Simpan', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  // Fungsi hapus data dari BookState
  void _deleteData(int id) {
    setState(() {
      BookState.masterBooks.removeWhere((element) => element['id'] == id);
    });
  }

  // Halaman Katalog Buku Utama (Sudah dilengkapi tombol Edit, Delete & Error image builder)
  Widget _buildBrowsePage() {
    final listBuku = BookState.masterBooks;

    if (listBuku.isEmpty) {
      return const Center(child: Text('Belum ada koleksi buku.'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: listBuku.length,
      itemBuilder: (context, index) {
        final item = listBuku[index];
        final String coverInput = item['coverUrl'] ?? '';

        return Card(
          elevation: 3,
          margin: const EdgeInsets.symmetric(vertical: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Render Otomatis dari Folder Assets dengan pengaman error
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: coverInput.isNotEmpty
                      ? Image.asset(
                          'assets/$coverInput',
                          width: 70,
                          height: 100,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 70,
                              height: 100,
                              color: Colors.brown[200],
                              child: const Icon(Icons.broken_image, color: Colors.white),
                            );
                          },
                        )
                      : Container(
                          width: 70,
                          height: 100,
                          color: Colors.brown[200],
                          child: const Icon(Icons.book, color: Colors.white),
                        ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['judul'] ?? '', 
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87)
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Penulis: ${item['penulis'] ?? ''}', 
                        style: TextStyle(color: Colors.grey[700], fontSize: 13, fontStyle: FontStyle.italic)
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.brown[100],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          item['genre'] ?? '',
                          style: TextStyle(color: Colors.brown[900], fontSize: 11, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        item['sinopsis'] != null && item['sinopsis'].toString().isNotEmpty
                            ? item['sinopsis']
                            : 'Tidak ada sinopsis.',
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                // Tombol Aksi Edit & Hapus Data
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.orange),
                      onPressed: () => _showFormDialog(
                        id: item['id'],
                        currentJudul: item['judul'],
                        currentPenulis: item['penulis'],
                        currentGenre: item['genre'],
                        currentSinopsis: item['sinopsis'],
                        currentCover: item['coverUrl'],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteData(item['id']),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[50],
      appBar: AppBar(
        backgroundColor: Colors.brown[800],
        elevation: 2,
        title: Row(
          children: [
            const Text('Goodreads Personal', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            const SizedBox(width: 40),
            
            // TOP NAVIGATION BAR
            TextButton(
              onPressed: () => setState(() => _currentSubPageIndex = 0),
              child: Text('Browse', style: TextStyle(color: Colors.white, fontWeight: _currentSubPageIndex == 0 ? FontWeight.bold : FontWeight.normal)),
            ),
            TextButton(
              onPressed: () => setState(() => _currentSubPageIndex = 1),
              child: Text('My Books', style: TextStyle(color: Colors.white, fontWeight: _currentSubPageIndex == 1 ? FontWeight.bold : FontWeight.normal)),
            ),
            TextButton(
              onPressed: () => setState(() => _currentSubPageIndex = 2),
              child: Text('Quiz Challenge 🎯', style: TextStyle(color: Colors.white, fontWeight: _currentSubPageIndex == 2 ? FontWeight.bold : FontWeight.normal)),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle, color: Colors.white),
            tooltip: 'Profil Pengguna',
            onPressed: () {
              Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              if (mounted) {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
              }
            },
          )
        ],
      ),
      body: _buildBody(), // Menampilkan halaman dinamis
      // FloatingActionButton hanya muncul jika kita sedang membuka tab 'Browse' (index 0)
      floatingActionButton: _currentSubPageIndex == 0
          ? FloatingActionButton(
              backgroundColor: Colors.brown[800],
              child: const Icon(Icons.add, color: Colors.white),
              onPressed: () => _showFormDialog(),
            )
          : null,
    );
  }
}