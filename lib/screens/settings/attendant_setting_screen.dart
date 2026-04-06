import 'package:flutter/material.dart';
import '../printer/thermal_printer_screen.dart';

class AttendantSettingScreen extends StatefulWidget {
  const AttendantSettingScreen({super.key});

  @override
  State<AttendantSettingScreen> createState() => _AttendantSettingScreenState();
}

class _AttendantSettingScreenState extends State<AttendantSettingScreen> {
  // States
  bool _confirmationMode = false;
  bool _autoSync = false;
  int _syncIntervalMins = 30;
  bool _storeAndForward = false;
  String _printerSize = '80mm';
  String _printAttachment = 'Print with Attachment';
  
  String? _vehicleType;
  String? _street;
  String? _area;
  String? _offenceType;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB), // Clean off-white background
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Attendant Setting',
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Scanner Preference'),
            _buildCardContainer(
              child: _buildSwitchTile(
                icon: Icons.qr_code_scanner,
                title: 'Confirmation Mode',
                value: _confirmationMode,
                onChanged: (val) => setState(() => _confirmationMode = val),
              ),
            ),
            const SizedBox(height: 24),

            _buildSectionTitle('Data Management'),
            _buildCardContainer(
              child: Column(
                children: [
                  _buildSwitchTile(
                    icon: Icons.sync,
                    title: 'Auto Sync',
                    value: _autoSync,
                    onChanged: (val) => setState(() => _autoSync = val),
                  ),
                  _buildDivider(),
                  _buildIntervalTile(),
                  _buildDivider(),
                  _buildSwitchTile(
                    icon: Icons.save_alt,
                    title: 'Store & Forward',
                    value: _storeAndForward,
                    onChanged: (val) => setState(() => _storeAndForward = val),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            _buildSectionTitle('Thermal Printer Preference'),
            _buildCardContainer(
              child: Column(
                children: [
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF3E0),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.print, color: Color(0xFFF5A623), size: 20),
                    ),
                    title: const Text('Thermal Printers', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xFF1F2937))),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Color(0xFF9CA3AF)),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => const ThermalPrinterScreen()),
                      );
                    },
                  ),
                  _buildDivider(),
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF3E0),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.receipt_long, color: Color(0xFFF5A623), size: 20),
                    ),
                    title: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _printerSize,
                        icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF9CA3AF)),
                        isExpanded: true,
                        style: const TextStyle(fontSize: 16, color: Color(0xFF4B5563), fontWeight: FontWeight.w500),
                        items: <String>['58mm', '80mm'].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) setState(() => _printerSize = val);
                        },
                      ),
                    ),
                  ),
                  _buildDivider(),
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF3E0),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.attachment, color: Color(0xFFF5A623), size: 20),
                    ),
                    title: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _printAttachment,
                        icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF9CA3AF)),
                        isExpanded: true,
                        style: const TextStyle(fontSize: 16, color: Color(0xFF4B5563), fontWeight: FontWeight.w500),
                        items: <String>['Print with Attachment', 'No Attachment'].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) setState(() => _printAttachment = val);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            _buildSectionTitle('Offence Preference'),
            _buildCardContainer(
              child: Column(
                children: [
                  _buildOffenceDropdownTile(
                    icon: Icons.directions_car,
                    title: 'Vehicle Type',
                    value: _vehicleType,
                    items: ['Car', 'Motorcycle', 'Van', 'Lorry', 'Bus'],
                    onChanged: (val) {
                      if (val != null) setState(() => _vehicleType = val);
                    },
                  ),
                  _buildDivider(),
                  _buildOffenceDropdownTile(
                    icon: Icons.location_on,
                    title: 'Street',
                    value: _street,
                    items: ['Street A', 'Street B', 'Street C', 'Street D'],
                    onChanged: (val) {
                      if (val != null) setState(() => _street = val);
                    },
                  ),
                  _buildDivider(),
                  _buildOffenceDropdownTile(
                    icon: Icons.map,
                    title: 'Area',
                    value: _area,
                    items: ['Area 1', 'Area 2', 'Area 3'],
                    onChanged: (val) {
                      if (val != null) setState(() => _area = val);
                    },
                  ),
                  _buildDivider(),
                  _buildOffenceDropdownTile(
                    icon: Icons.gavel,
                    title: 'Offence Type',
                    value: _offenceType,
                    items: ['Parking', 'Speeding', 'Traffic Light', 'Other'],
                    onChanged: (val) {
                      if (val != null) setState(() => _offenceType = val);
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0, bottom: 8.0),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: Color(0xFF6B7280),
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildCardContainer({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: const Color(0xFFF3F4F6)),
      ),
      child: child,
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: const Color(0xFF4B5563), size: 20),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Color(0xFF1F2937),
        ),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeThumbColor: const Color(0xFFF5A623),
        activeTrackColor: const Color(0xFFFDE68A),
      ),
    );
  }

  Widget _buildIntervalTile() {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(Icons.access_time, color: Color(0xFF4B5563), size: 20),
      ),
      title: const Text(
        'Sync Interval',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Color(0xFF1F2937),
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.remove_circle_outline, color: Color(0xFF9CA3AF), size: 24),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: () {
              if (_syncIntervalMins > 5) setState(() => _syncIntervalMins -= 5);
            },
          ),
          const SizedBox(width: 12),
          Text(
            '$_syncIntervalMins m',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF1F2937)),
          ),
          const SizedBox(width: 12),
          IconButton(
            icon: const Icon(Icons.add_circle_outline, color: Color(0xFFF5A623), size: 24),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: () {
              if (_syncIntervalMins < 120) setState(() => _syncIntervalMins += 5);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildOffenceDropdownTile({
    required IconData icon,
    required String title,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: const Color(0xFF4B5563), size: 20),
      ),
      title: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          hint: Text(
            title,
            style: const TextStyle(fontSize: 16, color: Color(0xFF9CA3AF), fontWeight: FontWeight.w500),
          ),
          icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF9CA3AF)),
          isExpanded: true,
          style: const TextStyle(fontSize: 16, color: Color(0xFF4B5563), fontWeight: FontWeight.w500),
          items: items.map((String val) {
            return DropdownMenuItem<String>(
              value: val,
              child: Text(val),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(height: 1, thickness: 1, color: Color(0xFFF3F4F6), indent: 56);
  }
}
