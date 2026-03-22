import 'package:flutter/material.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  String _selectedLanguage = 'English';

  final List<String> _languages = [
    'English',
    'Sinhala',
    'Tamil',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F7),
      appBar: AppBar(
        title: const Text('Language', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF2E7D32),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 20),
        itemCount: _languages.length,
        itemBuilder: (context, index) {
          final lang = _languages[index];
          return ListTile(
            title: Text(lang, style: const TextStyle(fontSize: 16)),
            trailing: _selectedLanguage == lang
                ? const Icon(Icons.check, color: Color(0xFF2E7D32))
                : null,
            onTap: () {
              setState(() {
                _selectedLanguage = lang;
              });
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Language changed to $lang'),
                backgroundColor: const Color(0xFF2E7D32),
                behavior: SnackBarBehavior.floating,
              ));
            },
            tileColor: Colors.white,
          );
        },
      ),
    );
  }
}
