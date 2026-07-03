import 'package:flutter/material.dart';
import '../states/book_state.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _q1Value = 0; // 1: Ringan/Sains, 2: Sihir, 3: Horor/Misteri
  int _q2Value = 0; // 1: Sejarah/Realita, 2: Fantasi Kerajaan, 3: Misteri Rumah Tua
  Map<String, dynamic>? _recommendedBook;

  void _generateRecommendation() {
    Map<String, dynamic> book;
    
    // Logika pengkondisian cerdas berbasis scoring pilihan ganda kuis
    if (_q1Value == 1 && _q2Value == 1) {
      book = BookState.masterBooks.firstWhere((b) => b['id'] == 1); // Bumi Manusia
    } else if (_q1Value == 1 && _q2Value == 2) {
      book = BookState.masterBooks.firstWhere((b) => b['id'] == 3); // Filosofi Teras
    } else if (_q1Value == 2 && _q2Value == 2) {
      book = BookState.masterBooks.firstWhere((b) => b['id'] == 5); // The Cruel Prince
    } else if (_q1Value == 2 && _q2Value == 1) {
      book = BookState.masterBooks.firstWhere((b) => b['id'] == 4); // Fire & Blood
    } else if (_q1Value == 3 && _q2Value == 3) {
      book = BookState.masterBooks.firstWhere((b) => b['id'] == 6); // Hill House
    } else {
      book = BookState.masterBooks.firstWhere((b) => b['id'] == 2); // Coraline
    }

    setState(() => _recommendedBook = book);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[50],
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 600),
          margin: const EdgeInsets.all(24),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
          child: ListView(
            shrinkWrap: true,
            children: [
              const Text('🎯 Personalized Reading Quiz', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.brown)),
              const Text('Jawab kuis ringkas ini untuk mengetahui buku yang cocok buat kamu selanjutnya!', style: TextStyle(color: Colors.grey)),
              const Divider(height: 30),

              // Pertanyaan 1
              const Text('1. Apa suasana/vibe cerita yang ingin kamu baca saat ini?', style: TextStyle(fontWeight: FontWeight.bold)),
              RadioListTile(title: const Text('Realistis, Berbobot & Memotivasi Diri'), value: 1, groupValue: _q1Value, onChanged: (v) => setState(() => _q1Value = v as int)),
              RadioListTile(title: const Text('Penuh Dunia Sihir, Peri & Kerajaan'), value: 2, groupValue: _q1Value, onChanged: (v) => setState(() => _q1Value = v as int)),
              RadioListTile(title: const Text('Gelap, Menyeramkan & Penuh Misteri Teka-teki'), value: 3, groupValue: _q1Value, onChanged: (v) => setState(() => _q1Value = v as int)),
              const SizedBox(height: 16),

              // Pertanyaan 2
              const Text('2. Latar tempat manakah yang paling menarik imajinasimu?', style: TextStyle(fontWeight: FontWeight.bold)),
              RadioListTile(title: const Text('Kisah Nyata Sejarah / Kehidupan Sehari-hari'), value: 1, groupValue: _q2Value, onChanged: (v) => setState(() => _q2Value = v as int)),
              RadioListTile(title: const Text('Kerajaan Megah Penuh Intrik Politik'), value: 2, groupValue: _q2Value, onChanged: (v) => setState(() => _q2Value = v as int)),
              RadioListTile(title: const Text('Rumah Tua Tua Kuno yang Berhantu'), value: 3, groupValue: _q2Value, onChanged: (v) => setState(() => _q2Value = v as int)),
              
              const SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.brown, padding: const EdgeInsets.symmetric(vertical: 16)),
                onPressed: (_q1Value == 0 || _q2Value == 0) ? null : _generateRecommendation,
                child: const Text('Dapatkan Rekomendasi Buku ✨', style: TextStyle(color: Colors.white)),
              ),

              if (_recommendedBook != null) ...[
                const Divider(height: 40),
                const Text('🎉 Buku Rekomendasi Untukmu:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green)),
                const SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset('assets/${_recommendedBook!['coverUrl']}', width: 70, height: 105, fit: BoxFit.cover),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(_recommendedBook!['judul'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                          Text('Penulis: ${_recommendedBook!['penulis']}', style: const TextStyle(fontStyle: FontStyle.italic)),
                          const SizedBox(height: 4),
                          Text(_recommendedBook!['sinopsis'], style: TextStyle(color: Colors.grey[600], fontSize: 13), maxLines: 3, overflow: TextOverflow.ellipsis),
                        ],
                      ),
                    )
                  ],
                )
              ]
            ],
          ),
        ),
      ),
    );
  }
}