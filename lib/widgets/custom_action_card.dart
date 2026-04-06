import 'package:flutter/material.dart';

class CustomActionCard extends StatelessWidget {
  final Widget icon;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;

  const CustomActionCard({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(color: const Color(0xFFE5E7EB)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.015),
              blurRadius: 10,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon,
          const SizedBox(height: 8.0),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 13.0,
              fontWeight: FontWeight.bold,
              color: Color(0xFF111111),
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 2.0),
            Text(
              subtitle!,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 11.0,
                color: Color(0xFF888888),
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    ));
  }
}

class SimpleActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool hasBadge;

  const SimpleActionCard({
    super.key,
    required this.icon,
    required this.title,
    this.hasBadge = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
            spreadRadius: 1,
          )
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 28.0, color: const Color(0xFF111111)),
                const SizedBox(height: 8.0),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF222222),
                  ),
                ),
              ],
            ),
          ),
          if (hasBadge)
            Positioned(
              right: -5,
              top: -5,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.black45,
                  shape: BoxShape.circle,
                ),
                child: const Text('?', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
              ),
            ),
        ],
      ),
    );
  }
}

// Custom icons based on the design
class CustomIcons {
  static Widget checkParkingIcon() {
    return Stack(
      alignment: Alignment.center,
      children: [
        const Icon(Icons.search, size: 36, color: Colors.black),
        Positioned(
          top: 8,
          left: 10,
          child: Container(
            padding: const EdgeInsets.all(2),
            decoration: const BoxDecoration(
              color: Color(0xFFF5A623),
              shape: BoxShape.circle,
            ),
            child: const Text('P', style: TextStyle(color: Colors.black, fontSize: 10, fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    );
  }

  static Widget createOffenceIcon() {
    return const Stack(
      children: [
        Icon(Icons.receipt_long_outlined, size: 36, color: Colors.black),
        Positioned(
          bottom: 0,
          right: -4,
          child: Icon(Icons.edit, size: 20, color: Color(0xFFF5A623)),
        ),
      ],
    );
  }

  static Widget physicalCouponIcon() {
    return const Stack(
      children: [
        Icon(Icons.description_outlined, size: 36, color: Colors.black),
        Positioned(
          bottom: 0,
          right: -4,
          child: Icon(Icons.shield_outlined, size: 20, color: Color(0xFFF5A623)),
        ),
      ],
    );
  }

  static Widget scanSeasonPassIcon() {
    return const Stack(
      alignment: Alignment.center,
      children: [
        Icon(Icons.filter_center_focus, size: 36, color: Colors.black),
        Icon(Icons.remove, size: 20, color: Color(0xFFF5A623)),
      ],
    );
  }
}
