import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isEditing = false;
  
  // Dummy State Data
  final String _name = 'JOHN DOE';
  final String _nric = '900101-14-5555'; // Dummy IC
  String _gender = 'Male';
  final String _phone = '+60 12-345 6789'; // Dummy Phone
  final String _email = 'johndoe@example.com'; 
  final String _address = '123 Main Street, Kuala Lumpur';
  String _status = 'Available';

  void _toggleEdit() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  Future<void> _handleCancel() async {
    final bool? shouldAbort = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.error_outline, color: Colors.red, size: 24),
            ),
            const SizedBox(width: 12),
            const Text('Abort Edit', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          ],
        ),
        content: const Text(
          'Abort the current edit?',
          style: TextStyle(fontSize: 15, color: Colors.black87),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel', style: TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.bold)),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Abort', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );

    if (shouldAbort == true) {
      _toggleEdit();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Profile',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Avatar
            Center(
              child: Container(
                width: 90,
                height: 90,
                decoration: const BoxDecoration(
                  color: Color(0xFFF5A623),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    )
                  ],
                ),
                child: Center(
                  child: Text(
                    _name.isNotEmpty ? _name[0] : 'U',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            // Info Card
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Account Information',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueGrey,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _isEditing ? _buildEditForm() : _buildViewMode(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: _isEditing
              ? Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _handleCancel,
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          side: const BorderSide(color: Colors.grey),
                        ),
                        child: const Text('Cancel', style: TextStyle(fontSize: 16, color: Colors.black87, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _toggleEdit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFF5A623),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 0,
                        ),
                        child: const Text('Submit', style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                )
              : ElevatedButton.icon(
                  onPressed: _toggleEdit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF5A623),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  icon: const Icon(Icons.edit, color: Colors.white, size: 20),
                  label: const Text('Edit', style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),
                ),
        ),
      ),
    );
  }

  Widget _buildViewMode() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildViewRow('Name', _name),
        const Divider(height: 24, thickness: 1, color: Color(0xFFF0F0F0)),
        _buildViewRow('NRIC', _nric),
        const Divider(height: 24, thickness: 1, color: Color(0xFFF0F0F0)),
        _buildViewRow('Gender', _gender),
        const Divider(height: 24, thickness: 1, color: Color(0xFFF0F0F0)),
        _buildViewRow('Phone', _phone),
        const Divider(height: 24, thickness: 1, color: Color(0xFFF0F0F0)),
        _buildViewRow('E-mail', _email),
        const Divider(height: 24, thickness: 1, color: Color(0xFFF0F0F0)),
        _buildViewRow('Address', _address),
        const Divider(height: 32, thickness: 1, color: Color(0xFFF0F0F0)),
        const Text(
          'Staff Status',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.blueGrey,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            const SizedBox(
              width: 100,
              child: Text(
                'Status',
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ),
            const Icon(Icons.check_circle, color: Colors.teal, size: 20),
            const SizedBox(width: 8),
            Text(
              _status,
              style: const TextStyle(fontSize: 15, color: Colors.black87, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildViewRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: const TextStyle(color: Colors.grey, fontSize: 14),
          ),
        ),
        Expanded(
          child: Text(
            value.isEmpty ? '-' : value,
            style: const TextStyle(fontSize: 15, color: Colors.black87, fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }

  Widget _buildEditForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTextField('Name as NRIC *', _name),
        const SizedBox(height: 16),
        _buildTextField('NRIC', _nric, isReadOnly: true),
        const SizedBox(height: 16),
        const Text('Gender', style: TextStyle(color: Colors.blueGrey, fontSize: 13, fontWeight: FontWeight.w600)),
        RadioGroup<String>(
          groupValue: _gender,
          onChanged: (val) {
            if (val != null) setState(() => _gender = val);
          },
          child: Row(
            children: [
              Radio<String>(
                value: 'Male',
                activeColor: const Color(0xFFF5A623),
              ),
              const Icon(Icons.male, color: Colors.blue, size: 18),
              const SizedBox(width: 4),
              const Text('Male', style: TextStyle(color: Colors.black87)),
              const SizedBox(width: 16),
              Radio<String>(
                value: 'Female',
                activeColor: const Color(0xFFF5A623),
              ),
              const Icon(Icons.female, color: Colors.pink, size: 18),
              const SizedBox(width: 4),
              const Text('Female', style: TextStyle(color: Colors.black87)),
            ],
          ),
        ),
        const SizedBox(height: 8),
        _buildTextField('Phone No. *', _phone),
        const SizedBox(height: 16),
        _buildTextField('E-mail', _email, isReadOnly: true),
        const SizedBox(height: 16),
        _buildTextField('Address', _address),
        const Divider(height: 32, thickness: 1, color: Color(0xFFF0F0F0)),
        const Text(
          'Staff Status',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.blueGrey,
          ),
        ),
        const SizedBox(height: 16),
        const Text('Available Status', style: TextStyle(color: Colors.blueGrey, fontSize: 13, fontWeight: FontWeight.w600)),
        RadioGroup<String>(
          groupValue: _status,
          onChanged: (val) {
            if (val != null) setState(() => _status = val);
          },
          child: Row(
            children: [
               Radio<String>(
                value: 'Available',
                activeColor: const Color(0xFFF5A623),
              ),
              const Text('Available', style: TextStyle(color: Colors.black87)),
              const SizedBox(width: 16),
              Radio<String>(
                value: 'Not Available',
                activeColor: const Color(0xFFF5A623),
              ),
              const Text('Not Available', style: TextStyle(color: Colors.black87)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(String label, String initialValue, {bool isReadOnly = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.blueGrey, fontSize: 13, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 6),
        TextFormField(
          initialValue: initialValue,
          readOnly: isReadOnly,
          decoration: InputDecoration(
            filled: isReadOnly,
            fillColor: isReadOnly ? Colors.blueGrey.withValues(alpha: 0.05) : Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: isReadOnly ? Colors.transparent : Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: isReadOnly ? Colors.transparent : const Color(0xFFF5A623), width: 2),
            ),
          ),
          style: TextStyle(
            color: isReadOnly ? Colors.grey.shade600 : Colors.black87,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
