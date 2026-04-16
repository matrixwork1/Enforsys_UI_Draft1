import 'package:flutter/material.dart';
import '../../widgets/elderly_keyboard/elderly_text_field.dart';

class CreateOffenceScreen extends StatefulWidget {
  const CreateOffenceScreen({super.key});

  @override
  State<CreateOffenceScreen> createState() => _CreateOffenceScreenState();
}

class _CreateOffenceScreenState extends State<CreateOffenceScreen> {
  final TextEditingController _plateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Create Offence',
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
            const Text(
              'Offence Details',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF374151)),
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              child: Column(
                children: [
                  _buildTextField(
                    label: 'Vehicle Plate Number',
                    hint: 'Enter plate number',
                    controller: _plateController,
                  ),
                  const Divider(height: 1, color: Color(0xFFF3F4F6)),
                  _buildDropdownField(
                    label: 'Offence Type',
                    value: '10 (1) Without displaying coupon(s)',
                    items: ['10 (1) Without displaying coupon(s)', '04 - Parking outside marked space'],
                  ),
                  const Divider(height: 1, color: Color(0xFFF3F4F6)),
                  _buildDropdownField(
                    label: 'Vehicle Type',
                    value: 'Car',
                    items: ['Car', 'Motorcycle', 'Van'],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF5A623), // Orange accent
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
                child: const Text('SUBMIT', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({required String label, required String hint, required TextEditingController controller}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: ElderlyTextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Color(0xFF9CA3AF), fontSize: 13),
          hintText: hint,
          hintStyle: const TextStyle(color: Color(0xFFD1D5DB)),
          border: InputBorder.none,
          floatingLabelBehavior: FloatingLabelBehavior.always,
        ),
      ),
    );
  }

  Widget _buildDropdownField({required String label, required String value, required List<String> items}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: DropdownButtonFormField<String>(
        initialValue: value,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Color(0xFF9CA3AF), fontSize: 13),
          border: InputBorder.none,
          floatingLabelBehavior: FloatingLabelBehavior.always,
        ),
        icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF9CA3AF)),
        items: items.map((String item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(item, style: const TextStyle(color: Color(0xFF1F2937), fontSize: 14)),
          );
        }).toList(),
        onChanged: (val) {},
      ),
    );
  }
}
