import 'package:flutter/material.dart';
import 'package:food_wms/customcontrols/apploadinglist.dart';

class RelocateScreen extends StatefulWidget {
  final String title;
  const RelocateScreen({super.key, required this.title});

  @override
  State<RelocateScreen> createState() => _RelocateScreenState();
}

class _RelocateScreenState extends State<RelocateScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body:
      //const Center(child: Text('Relocate Screen Content')),
      ShimmerListView(
        itemCount: 6,
        itemHeight: 100,
        verticalSpacing: 2,
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
      ),
    );
  }
}
