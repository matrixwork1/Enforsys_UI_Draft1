import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class NewOffenceScreen extends StatefulWidget {
  const NewOffenceScreen({super.key});

  @override
  State<NewOffenceScreen> createState() => _NewOffenceScreenState();
}

class _NewOffenceScreenState extends State<NewOffenceScreen> {
  bool _additionalInfoExpanded = false;
  final List<File> _selectedImages = [];
  final ImagePicker _picker = ImagePicker();
  final _plateController = TextEditingController();
  final _spaceController = TextEditingController();
  final _roadTaxController = TextEditingController();
  final _remarkController = TextEditingController();

  String? _selectedParkingArea;
  String _selectedVehicleType = 'Car';
  String? _selectedVehicleName;
  String _selectedOffenceType = '10 (1) Without displaying coupon(s)';

  final List<String> _parkingAreas = [
    'Dewan Suarah',
    'Jalan Pedada',
    'Jalan Sanyan',
    'Jalan Maju',
    'Jalan Tunku Abdul Rahman',
  ];

  final List<String> _vehicleTypes = ['Car', 'Motorcycle', 'Van', 'Lorry'];
  final List<String> _vehicleNames = ['Toyota Vios', 'Honda City', 'Perodua Myvi', 'Proton Saga'];
  final List<String> _offenceTypes = [
    '10 (1) Without displaying coupon(s)',
    '04 - Parking outside marked space',
    '05 - Overtime parking',
    '06 - Double parking',
  ];

  Future<void> _pickFromGallery() async {
    if (_selectedImages.length >= 3) {
      _showSnackBar('Maximum of 3 images allowed');
      return;
    }
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1200,
        maxHeight: 1200,
        imageQuality: 85,
      );
      if (pickedFile != null) {
        setState(() {
          _selectedImages.add(File(pickedFile.path));
        });
      }
    } catch (e) {
      _showSnackBar('Unable to access gallery');
    }
  }

  Future<void> _pickFromCamera() async {
    if (_selectedImages.length >= 3) {
      _showSnackBar('Maximum of 3 images allowed');
      return;
    }
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1200,
        maxHeight: 1200,
        imageQuality: 85,
      );
      if (pickedFile != null) {
        setState(() {
          _selectedImages.add(File(pickedFile.path));
        });
      }
    } catch (e) {
      _showSnackBar('Unable to access camera');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  void _submit() {
    // Validate required fields
    if (_plateController.text.isEmpty) {
      _showSnackBar('Please enter a plate number');
      return;
    }
    if (_selectedParkingArea == null) {
      _showSnackBar('Please select a parking area');
      return;
    }

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFF0FDF4),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.check_circle_outline, color: Color(0xFF10B981), size: 24),
            ),
            const SizedBox(width: 12),
            const Text('Confirm Submission', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
          ],
        ),
        content: const Text(
          'Are you sure you want to submit this offence record?',
          style: TextStyle(color: Color(0xFF6B7280), fontSize: 14, height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('Cancel', style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.w500)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              _showSnackBar('Offence submitted successfully');
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF10B981),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
            child: const Text('Submit', style: TextStyle(fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _plateController.dispose();
    _spaceController.dispose();
    _roadTaxController.dispose();
    _remarkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final dateStr =
        '${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year}';
    final hour = now.hour > 12 ? now.hour - 12 : (now.hour == 0 ? 12 : now.hour);
    final period = now.hour >= 12 ? 'PM' : 'AM';
    final timeStr =
        '${hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')} $period';

    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'New Offence',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Photo Evidence Section ──
                  _buildSectionHeader('Photo Evidence', Icons.camera_alt_outlined),
                  _buildImageSection(),
                  const SizedBox(height: 20),

                  // ── Offence Detail Section ──
                  _buildSectionHeader('Offence Detail', Icons.description_outlined),
                  _buildCard(
                    child: Column(
                      children: [
                        _buildInfoTile(
                          icon: Icons.calendar_today_outlined,
                          label: 'Date',
                          value: dateStr,
                        ),
                        _buildDivider(),
                        _buildInfoTile(
                          icon: Icons.access_time_outlined,
                          label: 'Time',
                          value: timeStr,
                        ),
                        _buildDivider(),
                        _buildDropdownTile(
                          icon: Icons.location_on_outlined,
                          label: 'Parking Area',
                          value: _selectedParkingArea,
                          hint: 'Select a parking area',
                          items: _parkingAreas,
                          onChanged: (val) => setState(() => _selectedParkingArea = val),
                        ),
                        _buildDivider(),
                        _buildInputTile(
                          icon: Icons.grid_view_outlined,
                          label: 'Space No.',
                          controller: _spaceController,
                          hint: 'Enter space number',
                        ),
                        _buildDivider(),
                        _buildInputTile(
                          icon: Icons.tag,
                          label: 'Plate No.',
                          controller: _plateController,
                          hint: 'Enter plate number',
                          textCapitalization: TextCapitalization.characters,
                        ),
                        _buildDivider(),
                        _buildDropdownTile(
                          icon: Icons.directions_car_outlined,
                          label: 'Vehicle Type',
                          value: _selectedVehicleType,
                          items: _vehicleTypes,
                          onChanged: (val) => setState(() => _selectedVehicleType = val ?? _selectedVehicleType),
                        ),
                        _buildDivider(),
                        _buildDropdownTile(
                          icon: Icons.directions_car_filled_outlined,
                          label: 'Vehicle Name',
                          value: _selectedVehicleName,
                          hint: 'Select vehicle',
                          items: _vehicleNames,
                          onChanged: (val) => setState(() => _selectedVehicleName = val),
                        ),
                        _buildDivider(),
                        _buildDropdownTile(
                          icon: Icons.warning_amber_rounded,
                          label: 'Offence Type',
                          value: _selectedOffenceType,
                          items: _offenceTypes,
                          onChanged: (val) => setState(() => _selectedOffenceType = val ?? _selectedOffenceType),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // ── Fine Amount Section ──
                  _buildSectionHeader('Fine Amount', Icons.payments_outlined),
                  _buildCard(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF5A623).withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Text(
                                  'RM',
                                  style: TextStyle(
                                    color: Color(0xFFF5A623),
                                    fontWeight: FontWeight.w700,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Text(
                            '10.00',
                            style: TextStyle(
                              color: Colors.grey[800],
                              fontWeight: FontWeight.w700,
                              fontSize: 20,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // ── Additional Info Section ──
                  InkWell(
                    onTap: () {
                      setState(() {
                        _additionalInfoExpanded = !_additionalInfoExpanded;
                      });
                    },
                    borderRadius: BorderRadius.circular(8),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                        children: [
                          _buildSectionHeader('Additional Info', Icons.info_outline),
                          const Spacer(),
                          AnimatedRotation(
                            turns: _additionalInfoExpanded ? 0.5 : 0,
                            duration: const Duration(milliseconds: 200),
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Icon(
                                Icons.keyboard_arrow_down,
                                color: Colors.black54,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  AnimatedCrossFade(
                    firstChild: const SizedBox.shrink(),
                    secondChild: Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: _buildCard(
                        child: Column(
                          children: [
                            _buildInputTile(
                              icon: Icons.receipt_long_outlined,
                              label: 'Road Tax No.',
                              controller: _roadTaxController,
                              hint: 'Enter road tax number',
                            ),
                            _buildDivider(),
                            _buildInputTile(
                              icon: Icons.note_alt_outlined,
                              label: 'Remark',
                              controller: _remarkController,
                              hint: 'Add a remark (optional)',
                              maxLines: 2,
                            ),
                          ],
                        ),
                      ),
                    ),
                    crossFadeState: _additionalInfoExpanded
                        ? CrossFadeState.showSecond
                        : CrossFadeState.showFirst,
                    duration: const Duration(milliseconds: 250),
                    sizeCurve: Curves.easeInOut,
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),

          // ── Bottom Submit Button ──
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 14,
              bottom: MediaQuery.of(context).padding.bottom == 0
                  ? 16
                  : MediaQuery.of(context).padding.bottom + 4,
            ),
            child: SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF5A623),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 0,
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check_circle_outline, size: 20),
                    SizedBox(width: 10),
                    Text(
                      'Submit Offence',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════
  //  IMAGE SECTION
  // ═══════════════════════════════════════════════════════

  Widget _buildImageSection() {
    return _buildCard(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            // Image preview or placeholder
            if (_selectedImages.isNotEmpty) ...[
              SizedBox(
                height: 140, // Height for the horizontal list
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _selectedImages.length,
                  itemBuilder: (context, index) {
                    return Container(
                      width: 140,
                      margin: const EdgeInsets.only(right: 12),
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.file(
                              _selectedImages[index],
                              width: 140,
                              height: 140,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            top: 6,
                            right: 6,
                            child: GestureDetector(
                              onTap: () => _removeImage(index),
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: 0.6),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.close, color: Colors.white, size: 16),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),
            ] else ...[
              Container(
                width: double.infinity,
                height: 120,
                decoration: BoxDecoration(
                  color: const Color(0xFFF9FAFB),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFFE5E7EB),
                    width: 1.5,
                    strokeAlign: BorderSide.strokeAlignInside,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add_photo_alternate_outlined,
                      size: 36,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'No image selected',
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
            ],

            // Gallery & Camera buttons (hide if max reached)
            if (_selectedImages.length < 3)
              Row(
                children: [
                  Expanded(
                    child: _buildImageButton(
                      icon: Icons.photo_library_outlined,
                      label: 'Gallery',
                      onTap: _pickFromGallery,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildImageButton(
                      icon: Icons.camera_alt_outlined,
                      label: 'Camera',
                      onTap: _pickFromCamera,
                    ),
                  ),
                ],
              ),
            if (_selectedImages.length >= 3)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  'Maximum capacity reached (3/3)',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFF5A623).withValues(alpha: 0.35)),
            color: const Color(0xFFF5A623).withValues(alpha: 0.05),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: const Color(0xFFF5A623), size: 22),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  color: Color(0xFFF5A623),
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════
  //  HELPER WIDGETS
  // ═══════════════════════════════════════════════════════

  Widget _buildSectionHeader(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: const Color(0xFFF5A623).withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: const Color(0xFFF5A623), size: 16),
          ),
          const SizedBox(width: 10),
          Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1F2937),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFFF5A623), size: 22),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  color: Color(0xFF9CA3AF),
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.3,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 15,
                  color: Color(0xFF1F2937),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownTile({
    required IconData icon,
    required String label,
    String? value,
    String? hint,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFFF5A623), size: 22),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF9CA3AF),
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.3,
                  ),
                ),
                DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: value,
                    hint: Text(
                      hint ?? 'Select',
                      style: const TextStyle(color: Color(0xFFBBBBBB), fontSize: 14),
                    ),
                    isExpanded: true,
                    isDense: true,
                    icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF9CA3AF), size: 20),
                    style: const TextStyle(fontSize: 14, color: Color(0xFF1F2937)),
                    items: items
                        .map((item) => DropdownMenuItem(
                              value: item,
                              child: Text(item),
                            ))
                        .toList(),
                    onChanged: onChanged,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputTile({
    required IconData icon,
    required String label,
    required TextEditingController controller,
    required String hint,
    int maxLines = 1,
    TextCapitalization textCapitalization = TextCapitalization.none,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
      child: Row(
        crossAxisAlignment:
            maxLines > 1 ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(top: maxLines > 1 ? 8 : 0),
            child: Icon(icon, color: const Color(0xFFF5A623), size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF9CA3AF),
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.3,
                  ),
                ),
                TextField(
                  controller: controller,
                  maxLines: maxLines,
                  textCapitalization: textCapitalization,
                  style: const TextStyle(fontSize: 14, color: Color(0xFF1F2937)),
                  decoration: InputDecoration(
                    hintText: hint,
                    hintStyle: const TextStyle(color: Color(0xFFBBBBBB), fontSize: 14),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 6),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(height: 1, thickness: 1, color: Color(0xFFF3F4F6), indent: 52);
  }
}
