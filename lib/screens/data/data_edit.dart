import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EditScreen extends StatefulWidget {
  final List<String> data;

  const EditScreen({Key? key, required this.data}) : super(key: key);

  @override
  _EditScreenState createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  late TextEditingController _controller1;
  late TextEditingController _controller3;
  String? _selectedAlignmentId;
  List<Map<String, dynamic>> _alignments = [];

  @override
  void initState() {
    super.initState();
    _controller1 = TextEditingController(text: widget.data[0]);
    _controller3 = TextEditingController(text: widget.data[2]);
    _selectedAlignmentId = widget.data[1];
    _fetchAlignments();
  }

  Future<void> _fetchAlignments() async {
    final response = await Supabase.instance.client
        .from('alignments')
        .select('id, name')
        .execute();

    if (response.data != null) {
      for (var item in response.data as List) {
        if (item["name"] == widget.data[1]) {
          _selectedAlignmentId = item["id"].toString();
        }
      }
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

  Future<void> _saveChanges() async {
    final response = await Supabase.instance.client
        .from('armies') // Replace with your table name
        .update({
      'name': _controller1.text,
      'alignment': _selectedAlignmentId,
      'image_url': _controller3.text,
    })
        .eq('id', widget.data[3]) // Assuming the ID is passed as the fourth element
        .execute();

    if (response.data != null) {
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Changes saved successfully')),
      );
    } else {
      // Handle error
      print('Error saving changes: ${response.data.toString()}');
    }
  }

  @override
  void dispose() {
    _controller1.dispose();
    _controller3.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Edit Army')),
        backgroundColor: Colors.red,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: TextFormField(
                controller: _controller1,
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
                controller: _controller3,
                decoration: const InputDecoration(labelText: 'Image URL'),
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal, letterSpacing: 1)
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveChanges,
              child: const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}