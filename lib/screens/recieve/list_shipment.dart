class ShipmentListItem {
  final String ponumber;
  final String mrrfileno;
  final String mode;
  final String modedescription;
  final String country;
  final String countrydescription;
  final String date;
  final String reference;

  ShipmentListItem({
    required this.ponumber,
    required this.mrrfileno,
    required this.mode,
    required this.modedescription,
    required this.country,
    required this.countrydescription,
    required this.date,
    required this.reference,
  });

  factory ShipmentListItem.fromJson(Map<String, dynamic> json) {
    return ShipmentListItem(
      ponumber: (json['PO_NUMBER'] == null) ? "" : json['PO_NUMBER'],
      mrrfileno: (json['MRR_FILE_NO'] == null) ? "" : json['MRR_FILE_NO'],
      mode: (json['SHIPMENT_MODE'] == null) ? "" : json['SHIPMENT_MODE'],
      modedescription:
          (json['SHIPMENT_MODE_DESC'] == null)
              ? ""
              : json['SHIPMENT_MODE_DESC'],
      country:
          (json['SHIPMENT_COUNTRY'] == null) ? "" : json['SHIPMENT_COUNTRY'],
      countrydescription:
          (json['SHIPMENT_COUNTRY_DESC'] == null)
              ? ""
              : json['SHIPMENT_COUNTRY_DESC'],
      date: (json['SHIPMENT_DATE'] == null) ? "" : json['SHIPMENT_DATE'],
      reference:
          (json['SHIPMENT_REFERENCE'] == null)
              ? ""
              : json['SHIPMENT_REFERENCE'],
    );
  }
}

class ShipmentModeListItem {
  final String description;
  final String mode;

  ShipmentModeListItem({required this.description, required this.mode});

  factory ShipmentModeListItem.fromJson(Map<String, dynamic> json) {
    return ShipmentModeListItem(
      description: (json['DESCRIPTION'] == null) ? "" : json['DESCRIPTION'],
      mode: (json['SHIPMENT_MODE'] == null) ? "" : json['SHIPMENT_MODE'],
    );
  }
}

class ShipmentCountryListItem {
  final String name;
  final String code;

  ShipmentCountryListItem({required this.name, required this.code});

  factory ShipmentCountryListItem.fromJson(Map<String, dynamic> json) {
    return ShipmentCountryListItem(
      name: (json['COUNTRY_NAME'] == null) ? "" : json['COUNTRY_NAME'],
      code: (json['COUNTRY_CODE'] == null) ? "" : json['COUNTRY_CODE'],
    );
  }
}
