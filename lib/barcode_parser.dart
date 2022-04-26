library barcode_parser;

import 'package:validators/validators.dart';

part 'models.dart';

class BarcodeParser {
  //***************************** PUBLIC METHODS *************************** //

  Barcode parse(String rawValue) {
    final type = _identifyType(rawValue);

    switch (type) {
      case BarcodeValueType.url:
        return _parseUrl(rawValue);
      case BarcodeValueType.wifi:
        return _parseWifi(rawValue);
      case BarcodeValueType.product:
        return _parseProduct(rawValue);
      case BarcodeValueType.contactInfo:
        return _parseContactInfo(rawValue);
      case BarcodeValueType.email:
        return _parseEmail(rawValue);
      case BarcodeValueType.calendarEvent:
        return _parseCalendarEvent(rawValue);
      case BarcodeValueType.location:
        return _parseLocation(rawValue);
      case BarcodeValueType.phone:
        return _parsePhone(rawValue);
      case BarcodeValueType.sms:
        return _parseSms(rawValue);
      case BarcodeValueType.whatsapp:
        return _parseWhatsapp(rawValue);
      case BarcodeValueType.twitter:
        return _parseTwitter(rawValue);
      case BarcodeValueType.instagram:
        return _parseInstagram(rawValue);
      case BarcodeValueType.linkedin:
        return _parseLinkedin(rawValue);
      case BarcodeValueType.facebook:
        return _parseFacebook(rawValue);
      default:
        return _parseText(rawValue);
    }
  }

  // *************************** PRIVATE METHODS *************************** //

  BarcodeValueType _identifyType(String rawValue) {
    if (rawValue.startsWith('https://www.facebook.com/')) {
      return BarcodeValueType.facebook;
    } else if (rawValue.startsWith('https://www.linkedin.com/')) {
      return BarcodeValueType.linkedin;
    } else if (rawValue.startsWith('https://instagram.com/')) {
      return BarcodeValueType.instagram;
    } else if (rawValue.startsWith('https://twitter.com/')) {
      return BarcodeValueType.twitter;
    } else if (rawValue.startsWith('https://wa.me/') ||
        rawValue.startsWith('https://api.whatsapp.com/')) {
      return BarcodeValueType.whatsapp;
    } else if (isURL(rawValue)) {
      return BarcodeValueType.url;
    } else if (rawValue.startsWith('WIFI') || rawValue.startsWith('wifi')) {
      return BarcodeValueType.wifi;
    } else if (_isProduct(rawValue)) {
      return BarcodeValueType.product;
    } else if (rawValue.startsWith('BEGIN:VCARD')) {
      return BarcodeValueType.contactInfo;
    } else if (rawValue.startsWith('SMTP:') ||
        rawValue.startsWith('mailto:') ||
        rawValue.startsWith('MATMSG:')) {
      return BarcodeValueType.email;
    } else if (rawValue.startsWith('BEGIN:VEVENT')) {
      return BarcodeValueType.calendarEvent;
    } else if (rawValue.startsWith('geo:') || rawValue.startsWith('GEO:')) {
      return BarcodeValueType.location;
    } else if (rawValue.startsWith('tel:') || rawValue.startsWith('TEL:')) {
      return BarcodeValueType.phone;
    } else if (rawValue.startsWith('SMSTO:') || rawValue.startsWith('smsto:')) {
      return BarcodeValueType.sms;
    } else {
      return BarcodeValueType.unknown;
    }
  }

  BarcodeContactInfo _parseContactInfo(String rawValue) {
    return BarcodeContactInfo(rawValue: rawValue);
  }

  BarcodeText _parseText(String rawValue) {
    return BarcodeText(rawValue: rawValue);
  }

  BarcodeEmail _parseEmail(String rawValue) {
    List<String> recipients = [];
    List<String> cc = [];
    List<String> bcc = [];
    String? subject;
    String? body;

    if (rawValue.startsWith('mailto:')) {
      final int recipientsStart = rawValue.indexOf('mailto:') + 7;
      int recipientsEnd = rawValue.indexOf('?', recipientsStart);
      if (recipientsEnd == -1) recipientsEnd = rawValue.length;
      final String recipientsRaw =
          rawValue.substring(recipientsStart, recipientsEnd);
      recipients = recipientsRaw.split(',');

      final int ccStart = rawValue.indexOf('cc=') + 3;
      int ccEnd = rawValue.indexOf('&', ccStart);
      if (ccEnd == -1) ccEnd = rawValue.length;
      final String ccRaw = rawValue.substring(ccStart, ccEnd);
      cc = ccRaw.split(',');

      final int bccStart = rawValue.indexOf('bcc=') + 4;
      int bccEnd = rawValue.indexOf('&', bccStart);
      if (bccEnd == -1) bccEnd = rawValue.length;
      final String bccRaw = rawValue.substring(bccStart, bccEnd);
      bcc = bccRaw.split(',');

      final int subjectStart = rawValue.indexOf('subject=') + 8;
      int subjectEnd = rawValue.indexOf('&', subjectStart);
      if (subjectEnd == -1) subjectEnd = rawValue.length;
      subject = rawValue.substring(subjectStart, subjectEnd);

      final int bodyStart = rawValue.indexOf('body=') + 5;
      int bodyEnd = rawValue.indexOf('&', bodyStart);
      if (bodyEnd == -1) bodyEnd = rawValue.length;
      body = rawValue.substring(bodyStart, bodyEnd);
    } else if (rawValue.startsWith('MATMSG:')) {
      final int recipientStart = rawValue.indexOf('TO:') + 3;
      int recipientEnd = rawValue.indexOf(';', recipientStart);
      if (recipientEnd == -1) recipientEnd = rawValue.length;
      recipients.add(rawValue.substring(recipientStart, recipientEnd));

      final int subjectStart = rawValue.indexOf('SUB:') + 4;
      int subjectEnd = rawValue.indexOf(';', subjectStart);
      if (subjectEnd == -1) subjectEnd = rawValue.length;
      subject = rawValue.substring(subjectStart, subjectEnd);

      final int bodyStart = rawValue.indexOf('BODY:') + 5;
      int bodyEnd = rawValue.indexOf(';', bodyStart);
      if (bodyEnd == -1) bodyEnd = rawValue.length;
      body = rawValue.substring(bodyStart, bodyEnd);
    } else if (rawValue.startsWith('SMTP:')) {
      const int recipientStart = 5;
      int recipientEnd = rawValue.indexOf(':', recipientStart);
      if (recipientEnd == -1) recipientEnd = rawValue.length;
      recipients.add(rawValue.substring(recipientStart, recipientEnd));

      final int subjectStart = recipientEnd + 1;
      int subjectEnd = rawValue.indexOf(':', subjectStart);
      if (subjectEnd == -1) subjectEnd = rawValue.length;
      subject = rawValue.substring(subjectStart, subjectEnd);

      final int bodyStart = subjectEnd + 1;
      final int bodyEnd = rawValue.length;
      body = rawValue.substring(bodyStart, bodyEnd);
    }

    return BarcodeEmail(
      rawValue: rawValue,
      recipients: recipients,
      cc: cc,
      bcc: bcc,
      subject: subject,
      body: body,
    );
  }

  BarcodeCalendarEvent _parseCalendarEvent(String rawValue) {
    return BarcodeCalendarEvent(rawValue: rawValue);
  }

  BarcodeProduct _parseProduct(String rawValue) {
    final int code = int.parse(rawValue);

    return BarcodeProduct(rawValue: rawValue, code: code);
  }

  BarcodeLocation _parseLocation(String rawValue) {
    double? latitude;
    double? longitude;

    final int latStart = rawValue.indexOf(':') + 1;
    final int latEnd = rawValue.indexOf(',', latStart);
    latitude = double.parse(rawValue.substring(latStart, latEnd));

    final int longStart = latEnd + 1;
    int longEnd = rawValue.indexOf(',', longStart);
    if (longEnd == -1) {
      longEnd = rawValue.length;
    }
    longitude = double.parse(rawValue.substring(longStart, longEnd));

    return BarcodeLocation(
      rawValue: rawValue,
      latitude: latitude,
      longitude: longitude,
    );
  }

  BarcodePhone _parsePhone(String rawValue) {
    final int start = rawValue.indexOf(':') + 1;
    final String number = rawValue.substring(start);

    return BarcodePhone(rawValue: rawValue, number: number);
  }

  BarcodeSms _parseSms(String rawValue) {
    final int numberStart = rawValue.indexOf(':') + 1;
    final int numberEnd = rawValue.indexOf(':', numberStart);
    String? number = rawValue.substring(numberStart, numberEnd);
    if (number.isEmpty) number = null;

    final int messageStart = rawValue.indexOf(':', numberEnd) + 1;
    String? message = rawValue.substring(messageStart);
    if (message.isEmpty) message = null;

    return BarcodeSms(
      rawValue: rawValue,
      phoneNumber: number,
      message: message,
    );
  }

  BarcodeUrl _parseUrl(String rawValue) {
    return BarcodeUrl(rawValue: rawValue, url: rawValue);
  }

  BarcodeWifi _parseWifi(String rawValue) {
    final int authStart = rawValue.indexOf('T:') + 2;
    final int authEnd = rawValue.indexOf(';', authStart);
    final String authRaw = rawValue.substring(authStart, authEnd);

    WifiEncryptionType encType;
    if (authRaw.toLowerCase() == 'wpa') {
      encType = WifiEncryptionType.wpa;
    } else if (authRaw.toLowerCase() == 'wep') {
      encType = WifiEncryptionType.wep;
    } else {
      encType = WifiEncryptionType.open;
    }

    final int ssidStart = rawValue.indexOf('S:') + 2;
    final int ssidEnd = rawValue.indexOf(';', ssidStart);
    String? ssid = rawValue.substring(ssidStart, ssidEnd);
    if (ssid.isEmpty) ssid = null;

    final int pwdStart = rawValue.indexOf('P:') + 2;
    final int pwdEnd = rawValue.indexOf(';', pwdStart);
    String? pwd = rawValue.substring(pwdStart, pwdEnd);
    if (pwd.isEmpty) pwd = null;

    return BarcodeWifi(
      rawValue: rawValue,
      ssid: ssid,
      password: pwd,
      encryptionType: encType,
    );
  }

  bool _isProduct(String rawValue) {
    try {
      int.parse(rawValue);
      return rawValue.length >= 8 && rawValue.length <= 13;
    } catch (_) {
      return false;
    }
  }

  BarcodeWhatsapp _parseWhatsapp(String rawValue) {
    String phone = '';
    String? message;

    if (rawValue.startsWith('https://wa.me/')) {
      const startIndex = 14;
      final endIndex = rawValue.indexOf('/', startIndex);

      if (endIndex == -1) {
        phone = rawValue.substring(startIndex, rawValue.length);
      } else {
        phone = rawValue.substring(startIndex, endIndex);
        message =
            rawValue.substring(rawValue.indexOf('text=') + 5, rawValue.length);
      }
    } else {
      final startIndex = rawValue.indexOf('phone=') + 6;
      phone = rawValue.substring(startIndex, rawValue.length);
    }

    String? unencodedMessage;
    if (message != null) {
      unencodedMessage = Uri.decodeFull(message);
    }

    return BarcodeWhatsapp(
      rawValue: rawValue,
      phoneNumber: phone,
      message: unencodedMessage,
    );
  }

  BarcodeTwitter _parseTwitter(String rawValue) {
    final startIndex = rawValue.indexOf('twitter.com/') + 12;
    final username = rawValue.substring(startIndex, rawValue.length);

    return BarcodeTwitter(rawValue: rawValue, username: username);
  }

  BarcodeInstagram _parseInstagram(String rawValue) {
    final startIndex = rawValue.indexOf('instagram.com/') + 14;
    final username = rawValue.substring(startIndex, rawValue.length);

    return BarcodeInstagram(rawValue: rawValue, username: username);
  }

  BarcodeLinkedin _parseLinkedin(String rawValue) {
    final startIndex = rawValue.indexOf('linkedin.com/in/') + 16;
    final username = rawValue.substring(startIndex, rawValue.length);

    return BarcodeLinkedin(rawValue: rawValue, username: username);
  }

  BarcodeFacebook _parseFacebook(String rawValue) {
    final startIndex = rawValue.indexOf('facebook.com/') + 13;
    final username = rawValue.substring(startIndex, rawValue.length);

    return BarcodeFacebook(rawValue: rawValue, username: username);
  }
}
