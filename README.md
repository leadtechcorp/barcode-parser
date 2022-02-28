# Barcode Parser

[![style: lint](https://img.shields.io/badge/style-lint-4BC0F5.svg)](https://pub.dev/packages/lint)

The objective of this package is to provide a mechanism to parse decoded values from barcodes into dart objects.

This is not a barcode scanner, in order to use this package you should previously have scanned and decoded a barcode.

## Features:

The package can parse barcodes containing the following data:

- URLs
- Wifi credentials
- Geo location
- Email
- SMS
- Phone
- Driver license
- Products (ISBN, EAN, UPC...)
- Plain text
- Social media links (WhatsApp, Twitter, Instagram, Linkedin and Facebook)

## Pending work:

The following types can be parsed and you will know their type but the parsing of their values is not currently supported:

- Contact information (VCard)
- Calendar event (VEvent)

## Sample usage:

```dart
String barcodeDecodedValue = 'This is the content of a barcode decoded to a String.';
    
BarcodeParser barcodeParser = BarcodeParser();
Barcode barcode = barcodeParser.parse(barcodeDecodedValue);
```

Once the code is parsed you will obtain an instance of the abstract class Barcode. You can then cast it to the appropriate type to obtain the values:

```dart
if (barcode.valueType == BarcodeValueType.url) {
  BarcodeUrl barcodeUrl = barcode as BarcodeUrl;
  print(barcodeUrl.url);
}
```

You can create a complete switch to detect all possible values:

```dart
switch (barcode.valueType) {
  case BarcodeValueType.url:
    BarcodeUrl barcodeUrl = barcode as BarcodeUrl;
    break;
  case BarcodeValueType.wifi:
    BarcodeWifi barcodeWifi = barcode as BarcodeWifi;
    break;
  case BarcodeValueType.contactInfo:
    BarcodeContactInfo barcodeContactInfo = barcode as BarcodeContactInfo;
    break;
  case BarcodeValueType.location:
    BarcodeLocation barcodeLocation = barcode as BarcodeLocation;
    break;
  case BarcodeValueType.email:
    BarcodeEmail barcodeEmail = barcode as BarcodeEmail;
    break;
  case BarcodeValueType.sms:
    BarcodeSms barcodeSms = barcode as BarcodeSms;
    break;
  case BarcodeValueType.calendarEvent:
    BarcodeCalendarEvent barcodeCalendarEvent =
        barcode as BarcodeCalendarEvent;
    break;
  case BarcodeValueType.phone:
    BarcodePhone barcodePhone = barcode as BarcodePhone;
    break;
  case BarcodeValueType.driverLicense:
    BarcodeDriverLicense barcodeDriverLicense =
        barcode as BarcodeDriverLicense;
    break;
  case BarcodeValueType.product:
    BarcodeProduct barcodeProduct = barcode as BarcodeProduct;
    break;
  case BarcodeValueType.text:
    BarcodeText barcodeText = barcode as BarcodeText;
    break;
  default:
    break;
}
```

## State of the package

This package is in an early stage, though it's currently used in production.

If you want to contribute, pull requests are welcome.
