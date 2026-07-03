import 'package:flutter/material.dart';
import '../states/book_state.dart';

class MyBooksScreen extends StatefulWidget {
  const MyBooksScreen({super.key});

  @override
  State<MyBooksScreen> createState() => _MyBooksScreenState();
}

class _MyBooksScreenState extends State<MyBooksScreen> {
  String _selectedShelfFilter = 'All'; // Filter rak utama

  // Controller untuk Form Review Baru
  Map<String, dynamic>? _selectedAutocompleteBook;
  String _selectedRadioShelf = 'Want to Read'; // Radio Button komponen pertemuan 7
  double _selectedRating = 5;
  final _commentController = TextEditingController();
  DateTime? _pickedDate;
  TimeOfDay? _pickedTime;

  void _openReviewDialog() {
    // Hanya buku yang status interaksinya ditandai 'Read' yang bisa di-review mendalam
    final availableBooks = BookState.masterBooks;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Update Progres & Tulis Review', style: TextStyle(fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: SizedBox(
              width: 450,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. FITUR AUTOCOMPLETE (Mencari judul buku di library Anda)
                  const Text('Pilih Buku dari Koleksi:', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Autocomplete<Map<String, dynamic>>(
                    displayStringForOption: (option) => option['judul'],
                    optionsBuilder: (TextEditingValue textEditingValue) {
                      if (textEditingValue.text == '') return const Iterable<Map<String, dynamic>>.empty();
                      return availableBooks.where((book) => book['judul']
                          .toLowerCase()
                          .contains(textEditingValue.text.toLowerCase()));
                    },
                    onSelected: (selection) {
                      setDialogState(() => _selectedAutocompleteBook = selection);
                    },
                  ),
                  const SizedBox(height: 16),

                  // 2. FITUR RADIO BUTTON (Pertemuan 7 - Shelves)
                  const Text('Pilih Rak Status Buku:', style: TextStyle(fontWeight: FontWeight.bold)),
                  Column(
                    children: ['Want to Read', 'Currently Reading', 'Read'].map((shelf) {
                      return RadioListTile<String>(
                        title: Text(shelf),
                        value: shelf,
                        groupValue: _selectedRadioShelf,
                        activeColor: Colors.brown,
                        onChanged: (value) {
                          setDialogState(() => _selectedRadioShelf = value!);
                        },
                      );
                    }).toList(),
                  ),

                  // Tampilkan form rating & DatePicker HANYA JIKA memilih status 'Read' (Selesai Baca)
                  if (_selectedRadioShelf == 'Read') ...[
                    const Divider(),
                    const Text('Rating (1-5):', style: TextStyle(fontWeight: FontWeight.bold)),
                    Slider(
                      value: _selectedRating,
                      min: 1,
                      max: 5,
                      divisions: 4,
                      label: _selectedRating.round().toString(),
                      activeColor: Colors.brown,
                      onChanged: (value) => setDialogState(() => _selectedRating = value),
                    ),
                    TextField(
                      controller: _commentController,
                      decoration: const InputDecoration(labelText: 'Tulis Ulasan/Komentar', hintText: 'Buku ini sangat...'),
                      maxLines: 2,
                    ),
                    const SizedBox(height: 12),

                    // 3. IMPLEMENTASI DATE & TIME PICKER (Sangat cocok untuk "Date Finished Reading")
                    const Text('Kapan Selesai Membaca?', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        ElevatedButton.icon(
                          icon: const Icon(Icons.date_range),
                          label: Text(_pickedDate == null 
                              ? 'Pilih Tanggal' 
                              : '${_pickedDate!.day}/${_pickedDate!.month}/${_pickedDate!.year}'),
                          onPressed: () async {
                            final date = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2020),
                              lastDate: DateTime(2030),
                            );
                            if (date != null) setDialogState(() => _pickedDate = date);
                          },
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton.icon(
                          icon: const Icon(Icons.access_time),
                          label: Text(_pickedTime == null 
                              ? 'Pilih Jam' 
                              : _pickedTime!.format(context)),
                          onPressed: () async {
                            final time = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            );
                            if (time != null) setDialogState(() => _pickedTime = time);
                          },
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.brown),
              onPressed: () {
                if (_selectedAutocompleteBook == null) return;
                
                // Simpan/Update state data interaksi lokal secara dinamis
                setState(() {
                  final bookId = _selectedAutocompleteBook!['id'];
                  BookState.userBookInteractions.removeWhere((element) => element['bookId'] == bookId);
                  
                  String dateTimeStr = '';
                  if (_pickedDate != null && _pickedTime != null) {
                    dateTimeStr = '${_pickedDate!.year}-${_pickedDate!.month}-${_pickedDate!.day} ${_pickedTime!.format(context)}';
                  }

                  BookState.userBookInteractions.add({
                    'bookId': bookId,
                    'shelf': _selectedRadioShelf,
                    'rating': _selectedRadioShelf == 'Read' ? _selectedRating.toInt() : 0,
                    'comment': _selectedRadioShelf == 'Read' ? _commentController.text : '',
                    'dateRead': dateTimeStr
                  });
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

  @override
  Widget build(BuildContext context) {
    // Menyaring list data buku berdasarkan filter kategori rak sebelah kiri di gambar mockup
    List<Map<String, dynamic>> filteredInteractions = _selectedShelfFilter == 'All'
        ? BookState.userBookInteractions
        : BookState.userBookInteractions.where((i) => i['shelf'] == _selectedShelfFilter).toList();

    return Scaffold(
      backgroundColor: Colors.brown[50],
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sidebar menu kiri persis seperti Layout Mockup Goodreads asli
          Container(
            width: 220,
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Bookshelves', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const Divider(),
                ...['All', 'Want to Read', 'Currently Reading', 'Read'].map((shelfName) {
                  final isSelected = _selectedShelfFilter == shelfName;
                  return ListTile(
                    title: Text(shelfName, style: TextStyle(fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
                    dense: true,
                    selected: isSelected,
                    selectedTileColor: Colors.brown[100],
                    onTap: () => setState(() => _selectedShelfFilter = shelfName),
                  );
                }),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.brown, minimumSize: const Size.fromHeight(40)),
                  icon: const Icon(Icons.rate_review, color: Colors.white, size: 16),
                  label: const Text('Update / Review', style: TextStyle(color: Colors.white, fontSize: 12)),
                  onPressed: _openReviewDialog,
                )
              ],
            ),
          ),
          // Konten Utama: List Tabel data buku hasil saringan
          Expanded(
            child: filteredInteractions.isEmpty
                ? const Center(child: Text('Tidak ada buku di rak ini.'))
                : ListView.builder(
                    padding: const EdgeInsets.all(20),
                    itemCount: filteredInteractions.length,
                    itemBuilder: (context, index) {
                      final interaction = filteredInteractions[index];
                      final book = BookState.masterBooks.firstWhere((b) => b['id'] == interaction['bookId']);

                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          leading: Image.asset('assets/${book['coverUrl']}', width: 50, height: 75, fit: BoxFit.cover),
                          title: Text(book['judul'], style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Penulis: ${book['penulis']} | Rak: ${interaction['shelf']}'),
                              if (interaction['shelf'] == 'Read') ...[
                                Row(
                                  children: List.generate(5, (i) => Icon(
                                    Icons.star, 
                                    size: 16, 
                                    color: i < interaction['rating'] ? Colors.amber : Colors.grey[300],
                                  )),
                                ),
                                if (interaction['comment'].toString().isNotEmpty)
                                  Text('Review: "${interaction['comment']}"', style: const TextStyle(fontStyle: FontStyle.italic)),
                                if (interaction['dateRead'].toString().isNotEmpty)
                                  Text('Selesai pada: ${interaction['dateRead']}', style: TextStyle(color: Colors.grey[600], fontSize: 11)),
                              ]
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          )
        ],
      ),
    );
  }
}