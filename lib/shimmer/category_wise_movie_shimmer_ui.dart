import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:story_box/utils/color.dart';

class CategoryWiseGridShimmer extends StatelessWidget {
  const CategoryWiseGridShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColor.shimmerBaseColor,
      highlightColor: Colors.grey.shade700,
      period: const Duration(milliseconds: 1500),
      child: GridView.builder(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 190), // Exact match with your real grid
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.68, // Same as your real grid
          crossAxisSpacing: 16,
          mainAxisSpacing: 10,
        ),
        itemCount: 10, // Show 10 shimmering cards (5 rows × 2 columns)
        itemBuilder: (context, index) {
          return const _CategoryWiseShimmerItem();
        },
      ),
    );
  }
}

// Single Shimmer Card – Reusable & Beautiful
class _CategoryWiseShimmerItem extends StatelessWidget {
  const _CategoryWiseShimmerItem();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Thumbnail
        Container(
          height: 180,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey.shade700,
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        const SizedBox(height: 10),

        // Title line 1
        Container(
          height: 14,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey.shade700,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        const SizedBox(height: 6),

        // Title line 2 (shorter)
        Container(
          height: 14,
          width: 100,
          decoration: BoxDecoration(
            color: Colors.grey.shade700,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        const SizedBox(height: 6),

        // Views / Duration (small text)
        Container(
          height: 12,
          width: 60,
          decoration: BoxDecoration(
            color: Colors.grey.shade700,
            borderRadius: BorderRadius.circular(6),
          ),
        ),
      ],
    );
  }
}
