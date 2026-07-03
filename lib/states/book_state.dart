class BookState {
  // 1. Data Mentah Buku Utama (Sesuai image_eba228.png)
  static final List<Map<String, dynamic>> masterBooks = [
    {
      'id': 1,
      'judul': 'Bumi Manusia',
      'penulis': 'Pramoedya Ananta Toer',
      'genre': 'Fiksi',
      'coverUrl': 'bumi_manusia.jpg',
      'sinopsis': 'Kisah perjuangan Minke di era kolonial Belanda...'
    },
    {
      'id': 2,
      'judul': 'Coraline',
      'penulis': 'Neil Gaiman',
      'genre': 'Misteri',
      'coverUrl': 'coraline.jpg',
      'sinopsis': 'Coraline menemukan sebuah pintu rahasia di rumah barunya...'
    },
    {
      'id': 3,
      'judul': 'Filosofi Teras',
      'penulis': 'Henry Manampiring',
      'genre': 'Self Dev',
      'coverUrl': 'filosofi_teras.jpg',
      'sinopsis': 'Panduan praktis filsafat Stoisisme kuno untuk mengatasi kekhawatiran mental...'
    },
    {
      'id': 4,
      'judul': 'Fire and Blood',
      'penulis': 'George R.R. Martin',
      'genre': 'Fantasi',
      'coverUrl': 'fire_and_blood.jpg',
      'sinopsis': 'Sejarah lengkap dinasti Targaryen...'
    },
    {
      'id': 5,
      'judul': 'The Cruel Prince',
      'penulis': 'Holly Black',
      'genre': 'Fantasi',
      'coverUrl': 'the_cruel_prince.jpg',
      'sinopsis': 'Kisah Jude, seorang manusia fana yang terperangkap dalam intrik politik...'
    },
    {
      'id': 6,
      'judul': 'The Haunting of Hill House',
      'penulis': 'Shirley Jackson',
      'genre': 'Misteri',
      'coverUrl': 'the_haunting_of_hill_house.jpg',
      'sinopsis': 'Kisah empat orang yang tinggal di sebuah rumah tua berhantu...'
    },
    {
      'id': 7,
      'judul': 'The Queen of Nothing',
      'penulis': 'Holly Black',
      'genre': 'Fantasi',
      'coverUrl': 'the_queen_of_nothing.jpg',
      'sinopsis': 'Kelanjutan kisah Jude di pembuangan...'
    },
    {
      'id': 8,
      'judul': 'The Wicked King',
      'penulis': 'Holly Black',
      'genre': 'Fantasi',
      'coverUrl': 'the_wicked_king.jpg',
      'sinopsis': 'Jude harus mempertahankan kendalinya atas raja Cardan yang licik...'
    },
  ];

  // 2. State untuk menyimpan data interaksi user (Personalized Data)
  // Format isi: {'bookId': 1, 'shelf': 'Want to Read', 'rating': 5, 'comment': 'Bagus', 'dateRead': '2026-07-03 22:00'}
  static List<Map<String, dynamic>> userBookInteractions = [
    {
      'bookId': 1,
      'shelf': 'Read',
      'rating': 5,
      'comment': 'Sangat menginspirasi perjuangan Minke!',
      'dateRead': '2026-06-15 19:30'
    },
    {
      'bookId': 3,
      'shelf': 'Currently Reading',
      'rating': 0,
      'comment': '',
      'dateRead': ''
    }
  ];
}