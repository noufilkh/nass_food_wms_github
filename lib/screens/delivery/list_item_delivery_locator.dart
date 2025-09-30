class DeliveryLocatorListItem {
  final String locatorid;
  final String locator;
  final String cnt;

  DeliveryLocatorListItem({
    required this.locatorid,
    required this.locator,
    required this.cnt,
  });

  factory DeliveryLocatorListItem.fromJson(Map<String, dynamic> json) {
    return DeliveryLocatorListItem(
      locatorid: (json['LOCATOR_ID'] == null) ? "" : json['LOCATOR_ID'],
      locator: (json['LOCATOR'] == null) ? "" : json['LOCATOR'],
      cnt: (json['CNT'] == null) ? "" : json['CNT'],
    );
  }
}
