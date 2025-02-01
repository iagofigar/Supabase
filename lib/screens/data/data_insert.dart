import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class InsertScreen extends StatefulWidget {
  @override
  _InsertScreenState createState() => _InsertScreenState();
}

class _InsertScreenState extends State<InsertScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();
  String? _selectedAlignmentId;
  List<Map<String, dynamic>> _alignments = [];

  @override
  void initState() {
    super.initState();
    _selectedAlignmentId = '1';
    _fetchAlignments();
  }

  Future<void> _fetchAlignments() async {
    final response = await Supabase.instance.client
        .from('alignments')
        .select('id, name')
        .execute();

    if (response.data != null) {
      setState(() {
        _alignments = (response.data as List)
            .map((e) => {'id': e['id'].toString(), 'name': e['name']})
            .toList();
      });
    } else {
      // Handle error
      print('Error fetching alignments: ${response.data.toString()}');
    }
  }

  Future<void> _insertData() async {
    final response = await Supabase.instance.client
        .from('armies')
        .insert({
      'name': _nameController.text,
      'alignment': _selectedAlignmentId,
      'image_url': _imageUrlController.text,
    })
        .execute();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Data inserted successfully')),
    );

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Create new Army')),
        backgroundColor: Colors.red,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal, letterSpacing: 1)
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: DropdownButtonFormField<String>(
                value: _selectedAlignmentId,
                decoration: const InputDecoration(labelText: 'Alignment'),
                items: _alignments.map((alignment) {
                  return DropdownMenuItem<String>(
                    value: alignment['id'],
                    child: Text(alignment['name'], style: TextStyle(fontSize: 16, fontFamily: GoogleFonts.outfit().fontFamily)),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedAlignmentId = value;
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: TextFormField(
                  controller: _imageUrlController,
                  decoration: const InputDecoration(labelText: 'Image URL'),
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal, letterSpacing: 1)
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _insertData,
              child: const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}