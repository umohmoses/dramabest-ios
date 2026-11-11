import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:story_box/utils/color.dart';

class CategoryGridShimmer extends StatelessWidget {
  const CategoryGridShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColor.shimmerBaseColor,
      highlightColor: Colors.grey.shade700,
      child: GridView.builder(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 0.68, // Same as your real grid
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: 12, // Show 12 shimmering items (4 rows × 3 columns)
        itemBuilder: (context, index) {
          return const _CategoryShimmerItem();
        },
      ),
    );
  }
}

// Single Shimmer Item (Reusable)
class _CategoryShimmerItem extends StatelessWidget {
  const _CategoryShimmerItem();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Thumbnail Shimmer
        Container(
          height: 130,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey[700],
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        const SizedBox(height: 10),

        // Title Shimmer (2 lines)
        Container(
          height: 12,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey[700],
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        const SizedBox(height: 6),
        Container(
          height: 12,
          width: 80,
          decoration: BoxDecoration(
            color: Colors.grey[700],
            borderRadius: BorderRadius.circular(6),
          ),
        ),
      ],
    );
  }
}
