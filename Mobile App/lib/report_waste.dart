import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ReportWaste extends StatefulWidget {
  const ReportWaste({super.key});

  @override
  State<ReportWaste> createState() => _ReportWasteState();
}

class _ReportWasteState extends State<ReportWaste> {
  final _formKey = GlobalKey<FormState>();
  final _desc = TextEditingController();
  String _type = 'overflow'; // overflow | uncollected | maintenance

  final List<Map<String, dynamic>> _submitted = [];

  XFile? _picked; // selected or captured image
  double? _lat;
  double? _lng;
  bool _busy = false;

  final ImagePicker _picker = ImagePicker();

  Future<void> _showImageSourceSheet() async {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Upload from Gallery'),
              onTap: () async {
                Navigator.pop(context);
                final x = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 85, maxWidth: 1600);
                if (x != null) {
                  setState(() => _picked = x);
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_camera_outlined),
              title: const Text('Camera'),
              onTap: () async {
                Navigator.pop(context);
                final x = await _picker.pickImage(source: ImageSource.camera, imageQuality: 85, maxWidth: 1600);
                if (x != null) {
                  setState(() => _picked = x);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  void _fakeGetLocation() {
    setState(() {
      _lat = 28.6315;
      _lng = 77.2167;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Fake GPS captured')),
    );
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    if (_lat == null || _lng == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please capture GPS')),
      );
      return;
    }
    if (_picked == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add a photo')),
      );
      return;
    }

    setState(() => _busy = true);
    Future.delayed(const Duration(milliseconds: 400), () {
      final item = {
        'id': 'C-${_submitted.length + 1}',
        'type': _type,
        'description': _desc.text.trim(),
        'imagePath': _picked!.path,
        'location': {'lat': _lat, 'lng': _lng},
        'status': 'pending',
        'timestamp': DateTime.now(),
      };
      setState(() {
        _submitted.insert(0, item);
        _busy = false;
        _desc.clear();
        _picked = null;
        _lat = null;
        _lng = null;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Report submitted')),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFF2E7D32);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Report Waste'),
        backgroundColor: primary,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildForm(primary),
          const SizedBox(height: 20),
          const Text('My Offline Submissions', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          ..._submitted.map((d) => Card(
            child: ListTile(
              leading: const Icon(Icons.assignment_outlined),
              title: Text(d['type'].toString().toUpperCase()),
              subtitle: Text(d['description'] ?? ''),
              trailing: Text(d['status'].toString().toUpperCase()),
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildForm(Color primary) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // Image tile -> opens sheet with Gallery/Camera
          InkWell(
            onTap: _showImageSourceSheet,
            borderRadius: BorderRadius.circular(12),
            child: Ink(
              height: 170,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey.shade100,
                border: Border.all(color: Colors.black12),
              ),
              child: Center(
                child: _picked == null
                    ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.add_a_photo_outlined, size: 32),
                    SizedBox(height: 8),
                    Text('Tap to add photo'),
                  ],
                )
                    : ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.file(
                    File(_picked!.path),
                    height: 170,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),

          DropdownButtonFormField<String>(
            value: _type,
            decoration: _decoration('Issue Type', const Icon(Icons.category_outlined)),
            items: const [
              DropdownMenuItem(value: 'overflow', child: Text('Overflowing bin')),
              DropdownMenuItem(value: 'uncollected', child: Text('Uncollected waste')),
              DropdownMenuItem(value: 'maintenance', child: Text('Damaged/maintenance required')),
            ],
            onChanged: (v) => setState(() => _type = v!),
          ),
          const SizedBox(height: 12),

          TextFormField(
            controller: _desc,
            decoration: _decoration('Description', const Icon(Icons.notes_outlined)),
            minLines: 3,
            maxLines: 5,
            validator: (v) => (v == null || v.trim().isEmpty) ? 'Describe the issue' : null,
          ),
          const SizedBox(height: 12),

          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 0),
            leading: const Icon(Icons.my_location_outlined),
            title: Text(_lat == null
                ? 'No location captured'
                : 'Lat: ${_lat!.toStringAsFixed(5)}, Lng: ${_lng!.toStringAsFixed(5)}'),
            trailing: ElevatedButton.icon(
              onPressed: _fakeGetLocation,
              icon: const Icon(Icons.gps_fixed, size: 18),
              label: const Text('Get GPS'),
            ),
          ),
          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: _busy ? null : _submit,
              child: _busy
                  ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : const Text('Submit Report', style: TextStyle(fontSize: 18)),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _decoration(String label, Icon prefix) {
    const primary = Color(0xFF2E7D32);
    return InputDecoration(
      labelText: label,
      prefixIcon: prefix,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: primary, width: 2),
      ),
    );
  }
}
