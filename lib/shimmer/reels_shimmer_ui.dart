import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:story_box/main.dart';
import 'package:story_box/utils/color.dart';

class ReelsShimmerUi extends StatelessWidget {
  const ReelsShimmerUi({super.key, this.isShowEpisode = false});

  final bool isShowEpisode;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColor.shimmer,
      highlightColor: Colors.grey.shade700,
      child: Column(
        children: [
          Column(
            children: [
              Row(
                children: [
                  if (isShowEpisode)
                    Container(
                      height: 35,
                      width: 35,
                      margin: const EdgeInsets.only(top: 40, left: 16),
                      decoration: const BoxDecoration(color: AppColor.shimmer, shape: BoxShape.circle),
                    ),
                  if (isShowEpisode)
                    Container(
                      height: 25,
                      width: 160,
                      margin: const EdgeInsets.only(top: 40, left: 16),
                      decoration: BoxDecoration(
                        color: AppColor.shimmer,
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  if (isShowEpisode)
                    Container(
                      height: 25,
                      width: 50,
                      margin: const EdgeInsets.only(top: 40, left: 20),
                      decoration: BoxDecoration(
                        color: AppColor.shimmer,
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  const Spacer(),
                  Container(
                    height: 40,
                    width: 40,
                    margin: const EdgeInsets.only(top: 40, left: 16, right: 16),
                    decoration: const BoxDecoration(color: AppColor.shimmer, shape: BoxShape.circle),
                  ),
                ],
              )
            ],
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  10.height,
                  if (!isShowEpisode)
                    Container(
                      height: 18,
                      width: 260,
                      margin: const EdgeInsets.only(left: 20, bottom: 5),
                      decoration: BoxDecoration(
                        color: AppColor.shimmer,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  6.height,
                  if (!isShowEpisode)
                    Container(
                      height: 12,
                      width: 280,
                      margin: const EdgeInsets.only(left: 20, bottom: 5),
                      decoration: BoxDecoration(
                        color: AppColor.shimmer,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  Container(
                    height: isShowEpisode ? 6 : 12,
                    width: isShowEpisode ? 300 : 200,
                    margin: const EdgeInsets.only(left: 20, bottom: 5),
                    decoration: BoxDecoration(
                      color: AppColor.shimmer,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  for (int i = 0; i < 4; i++)
                    Container(
                      height: 40,
                      width: 40,
                      margin: const EdgeInsets.only(bottom: 20, right: 16),
                      decoration: const BoxDecoration(color: AppColor.shimmer, shape: BoxShape.circle),
                    ),
                ],
              ),
            ],
          ),
          10.height,
        ],
      ),
      // child: Stack(
      //   children: [
      //     Positioned(
      //       right: 20,
      //       child: SizedBox(
      //         height: MediaQuery.of(context).size.height - Constant.bottomBarSize,
      //         width: 50,
      //         child: Column(
      //           children: [
      //             Container(
      //               height: 50,
      //               width: 50,
      //               margin: const EdgeInsets.only(top: 40),
      //               decoration: BoxDecoration(color: AppColor.shimmer, shape: BoxShape.circle),
      //             ),
      //             const Spacer(),
      //             for (int i = 0; i < 4; i++)
      //               Container(
      //                 height: 50,
      //                 width: 50,
      //                 margin: const EdgeInsets.only(bottom: 20),
      //                 decoration: BoxDecoration(color: AppColor.shimmer, shape: BoxShape.circle),
      //               ),
      //           ],
      //         ),
      //       ),
      //     ),
      //     Positioned(
      //       bottom: 10,
      //       child: Column(
      //         crossAxisAlignment: CrossAxisAlignment.start,
      //         children: [
      //           10.height,
      //           Container(
      //             height: 25,
      //             width: 200,
      //             margin: const EdgeInsets.only(left: 20, bottom: 5),
      //             decoration: BoxDecoration(
      //               color: AppColor.shimmer,
      //               borderRadius: BorderRadius.circular(5),
      //             ),
      //           ),
      //           10.height,
      //           for (int i = 0; i < 2; i++)
      //             Container(
      //               height: 18,
      //               width: 280,
      //               margin: const EdgeInsets.only(left: 20, bottom: 5),
      //               decoration: BoxDecoration(
      //                 color: AppColor.shimmer,
      //                 borderRadius: BorderRadius.circular(5),
      //               ),
      //             ),
      //         ],
      //       ),
      //     ),
      //   ],
      // ),
    );
  }
}
