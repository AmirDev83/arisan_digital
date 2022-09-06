import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerGroups extends StatelessWidget {
  const ShimmerGroups({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 4,
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(horizontal: 15),
        itemBuilder: ((context, index) {
          return Shimmer.fromColors(
            baseColor: Colors.grey.shade200,
            highlightColor: Colors.grey.shade500,
            child: Container(
                margin: const EdgeInsets.only(right: 5),
                height: 30,
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.0),
                  child: Center(),
                )),
          );
        }));
  }
}
