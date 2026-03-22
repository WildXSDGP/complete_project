import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../models/animal_type1.dart';
import '../models/location_info1.dart';
import '../services/location_service1.dart';
import '../services/sighting_service1.dart';
import '../widgets/animal_type_grid1.dart';
import '../widgets/photo_upload_widget1.dart';
import '../widgets/location_widget1.dart';
import '../widgets/info_banner1.dart';
import '../widgets/change_location_sheet1.dart';

class ReportSightingScreen extends StatefulWidget {
  const ReportSightingScreen({super.key});

  @override
  State<ReportSightingScreen> createState() => _ReportSightingScreenState();
}

class _ReportSightingScreenState extends State<ReportSightingScreen> {
  final _locationService  = LocationService();
  final _sightingService  = SightingService();
  final _imagePicker      = ImagePicker();
  final _notesController  = TextEditingController();

  AnimalType?  _selectedAnimal;
  File?        _photoFile;        // mobile only
  Uint8List?   _photoBytes;       // web only
  String?      _photoPath;        // used for submit (mobile path)

  LocationInfo _location          = LocationInfo.defaultLocation;
  bool         _isLocationLoading = false;
  bool         _isSubmitting      = false;

  bool get _hasPhoto => kIsWeb ? _photoBytes != null : _photoFile != null;

  @override
  void initState() {
    super.initState();
    _fetchLocation();
  }

  // ── GPS ───────────────────────────────────────────────────────────────────
  Future<void> _fetchLocation() async {
    setState(() => _isLocationLoading = true);
    try {
      final loc = await _locationService.getCurrentLocation();
      if (mounted) setState(() => _location = loc);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(e.toString()),
          behavior: SnackBarBehavior.floating,
          backgroundColor: const Color(0xFFE65100),
          action: SnackBarAction(
            label: 'Retry',
            textColor: Colors.white,
            onPressed: _fetchLocation,
          ),
        ));
      }
    } finally {
      if (mounted) setState(() => _isLocationLoading = false);
    }
  }

  // ── Camera permission (mobile only) ───────────────────────────────────────
  Future<bool> _requestCameraPermission() async {
    if (kIsWeb) return true; // web ලා permission_handler use නොකෙරෙයි
    final status = await Permission.camera.status;
    if (status.isGranted) return true;

    if (status.isPermanentlyDenied) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Camera Permission Required'),
            content: const Text(
              'Camera access is permanently blocked.\n\n'
              'Settings > App > Permissions > Camera\n'
              'ලා manually enable කරන්න.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  openAppSettings();
                },
                child: const Text('Open Settings'),
              ),
            ],
          ),
        );
      }
      return false;
    }

    final result = await Permission.camera.request();
    if (!result.isGranted && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Camera permission denied. Gallery use කරන්න.'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Color(0xFFE65100),
      ));
    }
    return result.isGranted;
  }

  // ── Photo picker ──────────────────────────────────────────────────────────
  Future<void> _onPhotoTap() async {
    // Web + Mobile දෙකෙහිම source dialog show කරනවා
    final source = await _showImageSourceDialog();

    if (source == null) return;

    // Permission check — mobile only (web ලා browser handle කරනවා)
    if (!kIsWeb && source == ImageSource.camera) {
      final granted = await _requestCameraPermission();
      if (!granted) return;
    }

    try {
      final picked = await _imagePicker.pickImage(
        source: source,
        imageQuality: 85,
        maxWidth: 1920,
        maxHeight: 1080,
        preferredCameraDevice: CameraDevice.rear,
      );

      if (picked != null && mounted) {
        if (kIsWeb) {
          // Web: File path নেই — bytes পড়ুন
          final bytes = await picked.readAsBytes();
          setState(() {
            _photoBytes = bytes;
            _photoPath  = picked.name;
          });
        } else {
          // Mobile: real File path
          setState(() {
            _photoFile = File(picked.path);
            _photoPath = picked.path;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            source == ImageSource.camera
                ? 'Camera open කරන්න බැරිවුණා.'
                : 'Photo pick කරන්න බැරිවුණා.',
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: const Color(0xFFD32F2F),
        ));
      }
    }
  }

  void _removePhoto() {
    setState(() {
      _photoFile  = null;
      _photoBytes = null;
      _photoPath  = null;
    });
  }

  Future<ImageSource?> _showImageSourceDialog() {
    return showModalBottomSheet<ImageSource>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Container(
              width: 40, height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFE0E0E0),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Add Photo',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            ListTile(
              leading: const CircleAvatar(
                backgroundColor: Color(0xFFE8F5E9),
                child: Icon(Icons.camera_alt_rounded, color: Color(0xFF2E7D32)),
              ),
              title: const Text('Take Photo'),
              subtitle: const Text('Use camera to capture sighting'),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            ListTile(
              leading: const CircleAvatar(
                backgroundColor: Color(0xFFE3F2FD),
                child: Icon(Icons.photo_library_rounded, color: Color(0xFF1565C0)),
              ),
              title: const Text('Choose from Gallery'),
              subtitle: const Text('Pick an existing photo'),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  // ── Location sheet ────────────────────────────────────────────────────────
  void _showChangeLocation() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ChangeLocationSheet(
        currentLocation: _location,
        onLocationSelected: (loc) => setState(() => _location = loc),
      ),
    );
  }

  // ── Submit ────────────────────────────────────────────────────────────────
  Future<void> _submit() async {
    if (_selectedAnimal == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please select an animal type'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Color(0xFFD32F2F),
      ));
      return;
    }

    setState(() => _isSubmitting = true);

    await _sightingService.submitReport(
      animalType: _selectedAnimal!,
      photoPath:  _photoPath,
      location:   _location,
      notes:      _notesController.text,
    );

    setState(() => _isSubmitting = false);
    if (!mounted) return;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(children: [
          Text('✅  ', style: TextStyle(fontSize: 20)),
          Text('Report Submitted'),
        ]),
        content: Text(
          'Your ${_selectedAnimal!.label} sighting at ${_location.name} '
          'has been submitted. Park rangers will verify it shortly.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _selectedAnimal = null;
                _removePhoto();
                _notesController.clear();
              });
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  // ── UI ────────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final canSubmit = _selectedAnimal != null && !_isSubmitting;
    final now    = TimeOfDay.now();
    final h      = now.hourOfPeriod == 0 ? 12 : now.hourOfPeriod;
    final m      = now.minute.toString().padLeft(2, '0');
    final period = now.period.name.toUpperCase();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2E7D32),
        leading: const BackButton(color: Colors.white),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Sighting',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: Colors.white)),
            Text('Help track wildlife',
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Colors.white70)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.my_location_rounded,
                color: Colors.white),
            tooltip: 'Refresh GPS',
            onPressed: _isLocationLoading ? null : _fetchLocation,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Select Animal Type',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            AnimalTypeGrid(
              selected: _selectedAnimal,
              onSelected: (a) => setState(() => _selectedAnimal = a),
            ),

            const SizedBox(height: 20),
            const Text('Upload Photo (Optional)',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
            const SizedBox(height: 10),
            PhotoUploadWidget(
              photo:      kIsWeb ? null : _photoFile,
              photoBytes: kIsWeb ? _photoBytes : null,
              onTap:      _onPhotoTap,
              onRemove:   _hasPhoto ? _removePhoto : null,
            ),

            const SizedBox(height: 20),
            const Text('Location',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
            const SizedBox(height: 10),
            LocationWidget(
              location:    _location,
              isLoading:   _isLocationLoading,
              onChangeTap: _showChangeLocation,
            ),

            const SizedBox(height: 20),
            const Text('Additional Notes (Optional)',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
            const SizedBox(height: 10),
            TextField(
              controller: _notesController,
              maxLines:   4,
              decoration: InputDecoration(
                hintText:  'Describe what you saw...',
                filled:    true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFE0E0E0))),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFE0E0E0))),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                        color: Color(0xFF2E7D32), width: 2)),
              ),
            ),

            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Time',
                    style: TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w500)),
                Text('$h:$m $period',
                    style: const TextStyle(
                        fontSize: 14, color: Color(0xFF757575))),
              ],
            ),

            const SizedBox(height: 20),
            SizedBox(
              width:  double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: canSubmit ? _submit : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor:         const Color(0xFF2E7D32),
                  foregroundColor:         Colors.white,
                  disabledBackgroundColor: const Color(0xFFBDBDBD),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                child: _isSubmitting
                    ? const SizedBox(
                        height: 22, width: 22,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white))
                    : const Text('Submit Sighting Report',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w600)),
              ),
            ),

            const SizedBox(height: 16),
            const InfoBanner(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
