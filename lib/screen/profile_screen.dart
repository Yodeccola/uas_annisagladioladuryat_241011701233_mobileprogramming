import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Data State Profil Yola (Bisa Diedit)
  String _nama = "Annisaa Gladiola Duryat (Yola)";
  String _nim = "241011701233";
  String _kelas = "04SIFE009";
  String _email = "jeonhawo@gmail.com";
  String _noHp = "081297555245";
  DateTime _tanggalLahir = DateTime(2003, 4, 11);
  String _alamat = "Goldberry Lane No. 7, The High Court, Insmire, Elfhame";
  String _bio = "Seorang mahasiswa yang lebih cepat paham lewat praktik daripada teori. Suka hal-hal visual, kreatif, dan detail—mulai dari menggambar sampai ngatur estetika hidup (dan aplikasi).";
  
  // Bumble Flair Badges
  String _mbti = "INFP";
  String _zodiac = "Aries ♈";

  // Gambar Lokal dari Folder Assets (Sesuai nama file eksak)
  final String _avatarAsset = "assets/profile.jpeg";
  final String _bannerAsset = "assets/header.jpeg";

  final List<String> _skills = ['Drawing', 'Makeup', 'Photo Editing', 'Cooking', 'Styling'];

  // Fungsi Lokal Pengganti DateFormat untuk mengubah DateTime menjadi Teks (Format: YYYY-MM-DD)
  String _formatTanggal(DateTime date) {
    String duaAngka(int n) => n >= 10 ? "$n" : "0$n";
    return "${date.year}-${duaAngka(date.month)}-${duaAngka(date.day)}";
  }

  // Fungsi memunculkan Date Picker
  Future<void> _selectDate(BuildContext context, StateSetter setDialogState, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _tanggalLahir,
      firstDate: DateTime(1990),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.brown[700]!,
              onPrimary: Colors.white,
              onSurface: Colors.brown[900]!,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setDialogState(() {
        _tanggalLahir = picked; // Simpan ke state date
        controller.text = _formatTanggal(picked);
      });
    }
  }

  // Dialog Form Edit Profil Komplit ala Bumble
  void _showEditProfileDialog() {
    final nameCtrl = TextEditingController(text: _nama);
    final bioCtrl = TextEditingController(text: _bio);
    final emailCtrl = TextEditingController(text: _email);
    final phoneCtrl = TextEditingController(text: _noHp);
    final addressCtrl = TextEditingController(text: _alamat);
    final dateCtrl = TextEditingController(text: _formatTanggal(_tanggalLahir));
    
    String selectedMbti = _mbti;
    String selectedZodiac = _zodiac;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text('Edit Profile & Flair ✨', style: TextStyle(color: Colors.brown[900], fontWeight: FontWeight.bold)),
          content: SizedBox(
            width: 500,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Nama Lengkap')),
                  TextField(controller: bioCtrl, decoration: const InputDecoration(labelText: 'About Me (Bio)'), maxLines: 2),
                  TextField(controller: emailCtrl, decoration: const InputDecoration(labelText: 'Email')),
                  TextField(controller: phoneCtrl, decoration: const InputDecoration(labelText: 'Nomor WhatsApp')),
                  TextField(controller: addressCtrl, decoration: const InputDecoration(labelText: 'Alamat Tinggal')),
                  
                  TextField(
                    controller: dateCtrl,
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: 'Tanggal Lahir',
                      suffixIcon: Icon(Icons.calendar_today, size: 18),
                    ),
                    onTap: () => _selectDate(context, setDialogState, dateCtrl),
                  ),
                  const SizedBox(height: 16),
                  
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: selectedMbti,
                          decoration: const InputDecoration(labelText: 'MBTI'),
                          items: ['INFP', 'INFJ', 'ENFP', 'ENFJ', 'INTJ', 'ENTJ', 'ISFP', 'ESFP']
                              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                              .toList(),
                          onChanged: (val) => setDialogState(() => selectedMbti = val!),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: selectedZodiac,
                          decoration: const InputDecoration(labelText: 'Horoscope'),
                          items: ['Aries ♈', 'Taurus ♉', 'Gemini ♊', 'Cancer ♋', 'Leo ♌', 'Virgo ♍', 'Libra ♎', 'Scorpio ♏', 'Sagittarius ♐', 'Capricorn ♑', 'Aquarius ♒', 'Pisces ♓']
                              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                              .toList(),
                          onChanged: (val) => setDialogState(() => selectedZodiac = val!),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.brown[700]),
              onPressed: () {
                setState(() {
                  _nama = nameCtrl.text;
                  _bio = bioCtrl.text;
                  _email = emailCtrl.text;
                  _noHp = phoneCtrl.text;
                  _alamat = addressCtrl.text;
                  _mbti = selectedMbti;
                  _zodiac = selectedZodiac;
                });
                Navigator.pop(context);
              },
              child: const Text('Simpan Changes 💖', style: TextStyle(color: Colors.white)),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[50],
      appBar: AppBar(
        // FIXED TITLE TO "My Profile"
        title: const Text('My Profile', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.brown[800],
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // AREA BANNER & FOTO PROFIL (Menggunakan File Lokal Kamu)
            Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: 220,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(_bannerAsset), // Fixed to header.jpeg
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(height: 220, color: Colors.black.withOpacity(0.15)),
                Positioned(
                  top: 150,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                    child: CircleAvatar(
                      radius: 65,
                      backgroundColor: Colors.brown[100],
                      backgroundImage: AssetImage(_avatarAsset), // Fixed to profile.jpeg
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 75),

            Text(_nama, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.brown[900])),
            const SizedBox(height: 4),
            Text('$_nim | $_kelas', style: TextStyle(color: Colors.grey[600], fontSize: 14, fontWeight: FontWeight.w500)),
            const SizedBox(height: 12),
            
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.brown[700]!),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
              onPressed: _showEditProfileDialog,
              icon: const Icon(Icons.edit_note, size: 20),
              label: const Text('Customize Profile & Badges'),
            ),
            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 850),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 4,
                      child: Column(
                        children: [
                          Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                children: [
                                  _buildInfoRow(Icons.email_outlined, _email),
                                  const Divider(height: 24),
                                  _buildInfoRow(Icons.phone_android_outlined, _noHp),
                                  const Divider(height: 24),
                                  _buildInfoRow(Icons.cake_outlined, _formatTanggal(_tanggalLahir)),
                                  const Divider(height: 24),
                                  _buildInfoRow(Icons.location_on_outlined, _alamat),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          
                          Card(
                            elevation: 2,
                            color: Colors.amber[50]!.withOpacity(0.7),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: BorderSide(color: Colors.amber[200]!)),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('My Vibe Badges ⚡', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.amber[900], fontSize: 14)),
                                  const SizedBox(height: 12),
                                  Wrap(
                                    spacing: 8,
                                    children: [
                                      Chip(
                                        avatar: const Icon(Icons.psychology, size: 16, color: Colors.amber),
                                        label: Text('MBTI: $_mbti', style: const TextStyle(fontWeight: FontWeight.bold)),
                                        backgroundColor: Colors.white,
                                      ),
                                      Chip(
                                        avatar: const Icon(Icons.auto_awesome, size: 16, color: Colors.amber),
                                        label: Text('Zodiac: $_zodiac', style: const TextStyle(fontWeight: FontWeight.bold)),
                                        backgroundColor: Colors.white,
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),

                    Expanded(
                      flex: 5,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('About Me', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.brown[900])),
                                  const SizedBox(height: 10),
                                  Text(_bio, style: TextStyle(color: Colors.grey[700], height: 1.5, fontSize: 13.5)),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Skills & Interests', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.brown[900])),
                                  const SizedBox(height: 12),
                                  Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    children: _skills.map((skill) => Chip(
                                      label: Text(skill, style: TextStyle(color: Colors.brown[900], fontSize: 12, fontWeight: FontWeight.w500)),
                                      backgroundColor: Colors.brown[50],
                                      side: BorderSide(color: Colors.brown[100]!),
                                    )).toList(),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.brown[600], size: 20),
        const SizedBox(width: 14),
        Expanded(child: Text(text, style: TextStyle(fontSize: 14, color: Colors.brown[900], fontWeight: FontWeight.w500))),
      ],
    );
  }
}