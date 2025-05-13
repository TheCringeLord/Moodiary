import 'package:flutter/material.dart';
import 'package:moodiary/common/widgets/custom_shape/container/rounded_container.dart';

class TMoodIcon extends StatelessWidget {
  final String imagePath;
  final bool isSelected;
  final VoidCallback onTap;
  final double size;

  const TMoodIcon({
    super.key,
    required this.imagePath,
    required this.onTap,
    this.isSelected = false,
    this.size = 50,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        alignment: Alignment.center,
        children: [
          TRoundedContainer(
            width: size,
            height: size,
            radius: size / 2,
            showBorder: isSelected,
            backgroundColor: isSelected
                ? Theme.of(context).primaryColor
                : Colors.transparent,
          ),
          ClipOval(
            child: ColorFiltered(
              colorFilter: ColorFilter.mode(
                isSelected ? Colors.transparent : Colors.grey,
                BlendMode.saturation,
              ),
              child: Image.asset(
                imagePath,
                width: size,
                height: size,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
