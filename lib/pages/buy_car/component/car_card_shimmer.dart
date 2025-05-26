import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

Widget buildCarShimmerCard() {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 5),
    width: 200,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              width: 200,
              height: 150,
              color: Colors.white,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              shimmerLine(width: 160, height: 14),
              const SizedBox(height: 10),
              shimmerLine(width: 100, height: 14),
              const SizedBox(height: 10),
              Row(
                children: [
                  shimmerLine(width: 40, height: 12),
                  const SizedBox(width: 10),
                  shimmerLine(width: 60, height: 12),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  shimmerCircle(size: 20),
                  const SizedBox(width: 10),
                  shimmerCircle(size: 20),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget shimmerLine({required double width, required double height}) {
  return Shimmer.fromColors(
    baseColor: Colors.grey[300]!,
    highlightColor: Colors.grey[100]!,
    child: Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
      ),
    ),
  );
}

Widget shimmerCircle({required double size}) {
  return Shimmer.fromColors(
    baseColor: Colors.grey[300]!,
    highlightColor: Colors.grey[100]!,
    child: Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
    ),
  );
}
