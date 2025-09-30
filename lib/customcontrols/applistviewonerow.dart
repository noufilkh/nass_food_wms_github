import 'dart:async';

import 'package:flutter/material.dart';

class AppListViewOneRow extends StatefulWidget {
  final String labelText;
  final FutureOr<List<String>> Function(String) suggestionsCallback;
  final ValueChanged<String>? onSelected;
  final Icon? leadingicon;
  final Widget Function(BuildContext, String) itemBuilder;
  final List<String> itemlist;

  const AppListViewOneRow({
    super.key,
    required this.labelText,
    required this.suggestionsCallback,
    required this.onSelected,
    this.leadingicon,
    required this.itemBuilder,
    required this.itemlist,
  });

  @override
  AppAutoCompleteFieldState createState() => AppAutoCompleteFieldState();
}

class AppAutoCompleteFieldState extends State<AppListViewOneRow> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child:
      // _isLoading
      //     ? ShimmerListView(
      //       itemCount: 6,
      //       itemHeight: 90,
      //       verticalSpacing: 2,
      //       baseColor: Colors.grey[300]!,
      //       highlightColor: Colors.grey[100]!,
      //       padding: EdgeInsets.all(0),
      //     )
      //     :
      ListView.builder(
        itemCount: widget.itemlist.length,
        itemBuilder: (context, index) {
          final deliveryNo = widget.itemlist[index];
          return Card(
            child: ListTile(
              title: Text(deliveryNo),
              trailing: IconButton(
                icon: Icon(Icons.play_arrow),
                onPressed: () => _openDeliveryLocatorScreen(deliveryNo),
              ),
              onLongPress: () {
                _openDeliveryLocatorScreen(deliveryNo);
              },
            ),
          );
        },
      ),
    );
  }

  void _openDeliveryLocatorScreen(String deliveryNo) {}
}
