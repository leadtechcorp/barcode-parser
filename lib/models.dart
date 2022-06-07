part of barcode_parser;

enum BarcodeValueType {
  unknown,
  contactInfo,
  email,
  phone,
  product,
  sms,
  text,
  url,
  wifi,
  location,
  calendarEvent,
  driverLicense,
  whatsapp,
  twitter,
  instagram,
  linkedin,
  facebook,
}

abstract class Barcode {
  final BarcodeValueType valueType;
  final String rawValue;

  Barcode({required this.valueType, required this.rawValue});
}

class BarcodeCalendarEvent extends Barcode {
  final DateTime? start;
  final DateTime? end;
  final String? description;
  final String? location;
  final String? organizer;
  final String? status;
  final String? summary;

  BarcodeCalendarEvent({
    required String rawValue,
    this.end,
    this.start,
    this.description,
    this.location,
    this.organizer,
    this.status,
    this.summary,
  }) : super(valueType: BarcodeValueType.calendarEvent, rawValue: rawValue);
}

class BarcodeLocation extends Barcode {
  final double? latitude;
  final double? longitude;

  BarcodeLocation({required String rawValue, this.latitude, this.longitude})
      : super(valueType: BarcodeValueType.location, rawValue: rawValue);
}

class BarcodeContactInfo extends Barcode {
  BarcodeContactInfo({
    required String rawValue,
  }) : super(valueType: BarcodeValueType.contactInfo, rawValue: rawValue);
}

class BarcodeDriverLicense extends Barcode {
  final String? addressCity;
  final String? addressState;
  final String? addressStreet;
  final String? addressZip;
  final DateTime? birthDate;
  final String? documentType;
  final DateTime? expiryDate;
  final String? firstName;
  final String? gender;
  final DateTime? issueDate;
  final String? issuingCountry;
  final String? lastName;
  final String? middleName;
  final String? licenseNumber;
  final String? jurisdiction;
  final int? aamvaVersion;
  final int? jurisdictionVersion;
  final int? aamvaFieldsEntries;

  BarcodeDriverLicense({
    required String rawValue,
    this.addressCity,
    this.addressState,
    this.addressStreet,
    this.addressZip,
    this.birthDate,
    this.documentType,
    this.expiryDate,
    this.firstName,
    this.gender,
    this.issueDate,
    this.issuingCountry,
    this.lastName,
    this.middleName,
    this.licenseNumber,
    this.jurisdiction,
    this.aamvaVersion,
    this.jurisdictionVersion,
    this.aamvaFieldsEntries,
  }) : super(valueType: BarcodeValueType.driverLicense, rawValue: rawValue);
}

class BarcodeEmail extends Barcode {
  final List<String> recipients;
  final List<String> cc;
  final List<String> bcc;
  final String? body;
  final String? subject;

  BarcodeEmail({
    required String rawValue,
    this.recipients = const [],
    this.cc = const [],
    this.bcc = const [],
    this.body,
    this.subject,
  }) : super(valueType: BarcodeValueType.email, rawValue: rawValue);
}

class BarcodePhone extends Barcode {
  final String? number;

  BarcodePhone({required String rawValue, this.number})
      : super(valueType: BarcodeValueType.phone, rawValue: rawValue);
}

class BarcodeSms extends Barcode {
  final String? message;
  final String? phoneNumber;

  BarcodeSms({required String rawValue, this.message, this.phoneNumber})
      : super(valueType: BarcodeValueType.sms, rawValue: rawValue);
}

class BarcodeUrl extends Barcode {
  final String? url;

  BarcodeUrl({required String rawValue, this.url})
      : super(valueType: BarcodeValueType.url, rawValue: rawValue);
}

enum WifiEncryptionType { open, wpa, wep }

class BarcodeWifi extends Barcode {
  final String? ssid;
  final String? password;
  final WifiEncryptionType? encryptionType;

  BarcodeWifi({
    required String rawValue,
    this.ssid,
    this.password,
    this.encryptionType,
  }) : super(valueType: BarcodeValueType.wifi, rawValue: rawValue);
}

class BarcodeProduct extends Barcode {
  final int code;

  BarcodeProduct({required String rawValue, required this.code})
      : super(valueType: BarcodeValueType.product, rawValue: rawValue);
}

class BarcodeText extends Barcode {
  BarcodeText({required String rawValue})
      : super(valueType: BarcodeValueType.text, rawValue: rawValue);
}

class BarcodeWhatsapp extends Barcode {
  final String phoneNumber;
  final String? message;

  BarcodeWhatsapp({
    required String rawValue,
    required this.phoneNumber,
    this.message,
  }) : super(valueType: BarcodeValueType.whatsapp, rawValue: rawValue);
}

class BarcodeTwitter extends Barcode {
  final String username;

  BarcodeTwitter({required String rawValue, required this.username})
      : super(valueType: BarcodeValueType.twitter, rawValue: rawValue);
}

class BarcodeInstagram extends Barcode {
  final String username;

  BarcodeInstagram({required String rawValue, required this.username})
      : super(valueType: BarcodeValueType.instagram, rawValue: rawValue);
}

class BarcodeLinkedin extends Barcode {
  final String username;

  BarcodeLinkedin({required String rawValue, required this.username})
      : super(valueType: BarcodeValueType.linkedin, rawValue: rawValue);
}

class BarcodeFacebook extends Barcode {
  final String username;

  BarcodeFacebook({required String rawValue, required this.username})
      : super(valueType: BarcodeValueType.facebook, rawValue: rawValue);
}
