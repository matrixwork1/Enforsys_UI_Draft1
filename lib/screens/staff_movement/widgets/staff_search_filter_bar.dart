import 'package:flutter/material.dart';

/// Search bar with a dedicated search button and a dropdown location filter.
class StaffSearchFilterBar extends StatefulWidget {
  final String hintText;
  final ValueChanged<String> onSearchSubmitted;
  final List<String> locationOptions;
  final String? selectedLocation;
  final ValueChanged<String?> onLocationChanged;

  const StaffSearchFilterBar({
    super.key,
    this.hintText = 'Search by name or PWID...',
    required this.onSearchSubmitted,
    this.locationOptions = const [],
    this.selectedLocation,
    required this.onLocationChanged,
  });

  @override
  State<StaffSearchFilterBar> createState() => _StaffSearchFilterBarState();
}

class _StaffSearchFilterBarState extends State<StaffSearchFilterBar> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _doSearch() {
    FocusScope.of(context).unfocus();
    widget.onSearchSubmitted(_controller.text);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Search row with explicit button
        Container(
          height: 46,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE5E7EB)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              const SizedBox(width: 14),
              const Icon(Icons.search, size: 20, color: Color(0xFF9CA3AF)),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: _controller,
                  onSubmitted: (_) => _doSearch(),
                  textInputAction: TextInputAction.search,
                  style: const TextStyle(fontSize: 14, color: Color(0xFF1F2937)),
                  decoration: InputDecoration(
                    hintText: widget.hintText,
                    hintStyle: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFFBDBDBD),
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                    isDense: true,
                  ),
                ),
              ),
              if (_controller.text.isNotEmpty)
                GestureDetector(
                  onTap: () {
                    _controller.clear();
                    widget.onSearchSubmitted('');
                    setState(() {});
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 6),
                    child: Icon(Icons.close, size: 18, color: Color(0xFF9CA3AF)),
                  ),
                ),
              // Search button
              GestureDetector(
                onTap: () {
                  _doSearch();
                  setState(() {});
                },
                child: Container(
                  height: 46,
                  width: 46,
                  decoration: const BoxDecoration(
                    color: Color(0xFFF5A623),
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(11),
                      bottomRight: Radius.circular(11),
                    ),
                  ),
                  child: const Icon(Icons.search, size: 20, color: Colors.white),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 10),

        // Location dropdown
        if (widget.locationOptions.isNotEmpty)
          Container(
            height: 44,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFE5E7EB)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.02),
                  blurRadius: 4,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: widget.selectedLocation,
                hint: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.location_on_outlined, size: 16, color: const Color(0xFFF5A623).withValues(alpha: 0.8)),
                    const SizedBox(width: 8),
                    const Text(
                      'All Locations',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFF6B7280)),
                    ),
                  ],
                ),
                isExpanded: true,
                icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF6B7280), size: 20),
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFF1F2937)),
                selectedItemBuilder: (context) {
                  return [
                    // "All Locations" item
                    Row(
                      children: [
                        Icon(Icons.location_on_outlined, size: 16, color: const Color(0xFFF5A623).withValues(alpha: 0.8)),
                        const SizedBox(width: 8),
                        const Text('All Locations', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFF1F2937))),
                      ],
                    ),
                    // Each location item
                    ...widget.locationOptions.map((loc) => Row(
                      children: [
                        const Icon(Icons.location_on, size: 16, color: Color(0xFFF5A623)),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(loc, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFF1F2937)),
                            overflow: TextOverflow.ellipsis),
                        ),
                      ],
                    )),
                  ];
                },
                items: [
                  const DropdownMenuItem<String>(
                    value: null,
                    child: Text('All Locations'),
                  ),
                  ...widget.locationOptions.map((loc) => DropdownMenuItem(
                    value: loc,
                    child: Text(loc, overflow: TextOverflow.ellipsis),
                  )),
                ],
                onChanged: (v) => widget.onLocationChanged(v),
              ),
            ),
          ),
      ],
    );
  }
}
