import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerListView extends StatelessWidget {
  final int itemCount;
  final double itemHeight;
  final double itemWidth;
  final double verticalSpacing;
  final double horizontalSpacing;
  final ShapeBorder shape;
  final Color baseColor;
  final Color highlightColor;
  final EdgeInsetsGeometry padding;

  const ShimmerListView({
    super.key,
    this.itemCount = 6,
    this.itemHeight = 80.0,
    this.itemWidth = double.infinity,
    this.verticalSpacing = 8.0,
    this.horizontalSpacing = 0.0,
    this.shape = const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(8.0)),
    ),
    this.baseColor = Colors.grey,
    this.highlightColor = Colors.grey,
    this.padding = const EdgeInsets.all(8.0),
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Shimmer.fromColors(
        baseColor: baseColor,
        highlightColor: highlightColor,
        child: ListView.separated(
          itemCount: itemCount,
          itemBuilder: (context, index) {
            return SizedBox(
              width: itemWidth,
              height: itemHeight,
              child: Card(
                elevation: 0,
                shape: shape,
                color:
                    Colors.white, // Use white or a light color to show shimmer
              ),
            );
          },
          separatorBuilder: (context, index) {
            return SizedBox(height: verticalSpacing, width: horizontalSpacing);
          },
        ),
      ),
    );
  }
}
