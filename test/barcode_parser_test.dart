import 'package:barcode_parser/barcode_parser.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BarcodeParser -', () {
    // ***************************** CONSTANTS ***************************** //

    const _vcard = '''
BEGIN:VCARD
VERSION:3.0
FN;CHARSET=UTF-8:FirstNameValue MiddleNameValue LastNameValue
N;CHARSET=UTF-8:LastNameValue;FirstNameValue;MiddleNameValue;PrefixValue;SuffixValue
NICKNAME;CHARSET=UTF-8:NicknameValue
GENDER:O
UID;CHARSET=UTF-8:OtherUidValue
BDAY:19740605
ANNIVERSARY:19991107
EMAIL;CHARSET=UTF-8;type=HOME,INTERNET:sampleemail@test.com
EMAIL;CHARSET=UTF-8;type=WORK,INTERNET:workemail@test.com
TEL;TYPE=CELL:85214569
TEL;TYPE=PAGER:852146984
TEL;TYPE=HOME,VOICE:65489521
TEL;TYPE=WORK,VOICE:45124487
TEL;TYPE=HOME,FAX:123548795
TEL;TYPE=WORK,FAX:654987544
LABEL;CHARSET=UTF-8;TYPE=HOME:LabelValue
ADR;CHARSET=UTF-8;TYPE=HOME:;;StreetValue;CityValue;StateValue;PostalCodeValue;CountryValue
LABEL;CHARSET=UTF-8;TYPE=WORK:WorkLabelValue
ADR;CHARSET=UTF-8;TYPE=WORK:;;WorkStreetValue;WorkCityValue;WorkStateValue;WorkPostalValue;WorkCountryValue
TITLE;CHARSET=UTF-8:TitleValue
ROLE;CHARSET=UTF-8:RoleValue
ORG;CHARSET=UTF-8:OrganizationValue
URL;CHARSET=UTF-8:http://someurl.com
URL;type=WORK;CHARSET=UTF-8:WorkUrlValue
NOTE;CHARSET=UTF-8:OtherNoteValue
X-SOCIALPROFILE;CHARSET=UTF-8;TYPE=facebook:https://facebook.com
X-SOCIALPROFILE;CHARSET=UTF-8;TYPE=twitter:https://twitter.com
X-SOCIALPROFILE;CHARSET=UTF-8;TYPE=linkedin:https://linkedin.com
X-SOCIALPROFILE;CHARSET=UTF-8;TYPE=instagram:https://instagram.com
X-SOCIALPROFILE;CHARSET=UTF-8;TYPE=youtube:https://youtube.com
X-SOCIALPROFILE;CHARSET=UTF-8;TYPE=SocialCustomLabel:https://custom.com
REV:2021-07-20T15:35:16.489Z
END:VCARD
    ''';

    const _emailMailtoComplex =
        'mailto:rec0@test.com,rec1@test.com,rec2@test.com?subject=Again the subject&cc=cc1@test.com,cc2@test.com&bcc=bcc1@test.com,bcc2@test.com,bcc3@test.com&body=Finally we have the message body';
    const _emailMatmsgSimple =
        'MATMSG:TO:email@email.com;SUB:asunto;BODY:mensaje;;';
    const _emailSmtpSimple =
        'SMTP:email@test.com:Subject of the message:Email body message';

    const _vEventStartEnd = '''
BEGIN:VEVENT
DTSTART:20200213T104200
DTEND:20200213T114200
END:VEVENT
    ''';
    const _vEventTitleDescriptionStartEnd = '''
BEGIN:VEVENT
SUMMARY:Title of the event
DESCRIPTION:Some description
LOCATION:Australia
DTSTART:20200213T104200
DTEND:20200213T114200
END:VEVENT
    ''';

    const _geoBunkers = 'geo:41.419290,2.161652,500';
    const _geoLeuuwarden = 'geo:53.20065838148934,5.800003829500944,500';

    const _phone = 'tel:555-555-5555';

    const _smsMessage = 'SMSTO::A message without phone.';
    const _smsTo = 'SMSTO:321654987:';
    const _smsToLongMessageSemicolons =
        'SMSTO:654987321:This is a long message, with some symbols: here and there - just to check that everything works';
    const _smsToMessage = 'SMSTO:666999777:content of the SMS';
    const _smsToLowercase = 'smsto:666999777:message';

    const _textLong =
        'bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla';
    const _textShort = 'sample text';

    const _urlShort = 'https://agilemanifesto.org/';
    const _urlLong =
        'https://stackoverflow.com/questions/27465851/how-should-i-handle-very-very-long-url';

    const _wifiOpen = 'WIFI:S:NoneSsid;T:nopass;P:;;';
    const _wifiWep = 'WIFI:S:WepSsid;T:WEP;P:b8F6xd;;';
    const _wifiWpa = 'WIFI:S:WpaSsid;T:WPA;P:suP¬rSecret8;;';

    const _productIsbn = '9781234567897';
    const _productEan8 = '95050003';
    const _productUpcA = '614141000036';
    const _productUpcE = '06141939';
    const _productEan13 = '9501101530003';

    const _whatsappSimple = 'https://wa.me/124681112';
    const _whatsappMessage =
        'https://wa.me/124681112/?text=message%20to%20be%20delivered';
    const _whatsappApi = 'https://api.whatsapp.com/send?phone=124681112';

    const _twitter = 'https://twitter.com/username';

    const _instagram = 'https://instagram.com/username';

    const _linkedin = 'https://www.linkedin.com/in/username';

    const _facebook = 'https://www.facebook.com/username';

    const _driverLicense =
        "@\x0a\x1e\x0dANSI 636000100002DL00410278ZV03190008DLDAQT64235789\x0aDCSSAMPLE\x0aDDEN\x0aDACMICHAEL\x0aDDFN\x0aDADJOHN\x0aDDGN\x0aDCUJR\x0aDCAD\x0aDCBK\x0aDCDPH\x0aDBD06062019\x0aDBB06061986\x0aDBA12102024\x0aDBC1\x0aDAU068 in\x0aDAYBRO\x0aDAG2300 WEST BROAD STREET\x0aDAIRICHMOND\x0aDAJVA\x0aDAK232690000\x0aDCF2424244747474786102204\x0aDCGUSA\x0aDCK123456789\x0aDDAF\x0aDDB06062018\x0aDDC06062020\x0aDDD1\x0dZVZVA01\x0d";

    // ******************************** VARS ******************************* //

    late BarcodeParser parser;

    // ******************************* SETUP ******************************* //

    setUp(() {
      parser = BarcodeParser();
    });

    // ******************************** TESTS ****************************** //

    group('when calling parse()', () {
      group('given barcode is a QR VCard', () {
        test('test vcard', () {
          final barcode = parser.parse(_vcard);
          assert(barcode is BarcodeContactInfo);
          expect(barcode.rawValue, _vcard);
        });
      });

      group('given barcode is a QR email', () {
        test('test mailto complex', () {
          final barcode = parser.parse(_emailMailtoComplex);
          assert(barcode is BarcodeEmail);
          expect(barcode.rawValue, _emailMailtoComplex);

          final email = barcode as BarcodeEmail;

          expect(email.recipients[0], 'rec0@test.com');
          expect(email.recipients[1], 'rec1@test.com');
          expect(email.recipients[2], 'rec2@test.com');

          expect(email.cc[0], 'cc1@test.com');
          expect(email.cc[1], 'cc2@test.com');

          expect(email.bcc[0], 'bcc1@test.com');
          expect(email.bcc[1], 'bcc2@test.com');
          expect(email.bcc[2], 'bcc3@test.com');

          expect(email.subject, 'Again the subject');
          expect(email.body, 'Finally we have the message body');
        });
        test('test MATMSG simple', () {
          final barcode = parser.parse(_emailMatmsgSimple);
          assert(barcode is BarcodeEmail);
          expect(barcode.rawValue, _emailMatmsgSimple);

          final email = barcode as BarcodeEmail;

          expect(email.recipients[0], 'email@email.com');
          expect(email.subject, 'asunto');
          expect(email.body, 'mensaje');
        });
        test('test SMTP simple', () {
          final barcode = parser.parse(_emailSmtpSimple);
          assert(barcode is BarcodeEmail);
          expect(barcode.rawValue, _emailSmtpSimple);

          final email = barcode as BarcodeEmail;

          expect(email.recipients[0], 'email@test.com');
          expect(email.subject, 'Subject of the message');
          expect(email.body, 'Email body message');
        });
      });

      group('given barcode is a QR event', () {
        test('test start end', () {
          final barcode = parser.parse(_vEventStartEnd);
          assert(barcode is BarcodeCalendarEvent);
          expect(barcode.rawValue, _vEventStartEnd);
        });
        test('test title description start end', () {
          final barcode = parser.parse(_vEventTitleDescriptionStartEnd);
          assert(barcode is BarcodeCalendarEvent);
          expect(barcode.rawValue, _vEventTitleDescriptionStartEnd);
        });
      });

      group('given barcode is a product code', () {
        test('test ISBN', () {
          final barcode = parser.parse(_productIsbn);
          assert(barcode is BarcodeProduct);
          expect(barcode.rawValue, _productIsbn);

          final product = barcode as BarcodeProduct;

          expect(product.code, 9781234567897);
        });
        test('test EAN 8', () {
          final barcode = parser.parse(_productEan8);
          assert(barcode is BarcodeProduct);
          expect(barcode.rawValue, _productEan8);

          final product = barcode as BarcodeProduct;

          expect(product.code, 95050003);
        });
        test('test EAN 13', () {
          final barcode = parser.parse(_productEan13);
          assert(barcode is BarcodeProduct);
          expect(barcode.rawValue, _productEan13);

          final product = barcode as BarcodeProduct;

          expect(product.code, 9501101530003);
        });
        test('test UPC A', () {
          final barcode = parser.parse(_productUpcA);
          assert(barcode is BarcodeProduct);
          expect(barcode.rawValue, _productUpcA);

          final product = barcode as BarcodeProduct;

          expect(product.code, 614141000036);
        });
        test('test UPC E', () {
          final barcode = parser.parse(_productUpcE);
          assert(barcode is BarcodeProduct);
          expect(barcode.rawValue, _productUpcE);

          final product = barcode as BarcodeProduct;

          expect(product.code, 06141939);
        });
      });

      group('given barcode is a QR location', () {
        test('test bunkers', () {
          final barcode = parser.parse(_geoBunkers);
          assert(barcode is BarcodeLocation);
          expect(barcode.rawValue, _geoBunkers);

          final geo = barcode as BarcodeLocation;

          expect(geo.latitude, 41.419290);
          expect(geo.longitude, 2.161652);
        });

        test('test leeuwarden', () {
          final barcode = parser.parse(_geoLeuuwarden);
          assert(barcode is BarcodeLocation);
          expect(barcode.rawValue, _geoLeuuwarden);

          final geo = barcode as BarcodeLocation;

          expect(geo.latitude, 53.20065838148934);
          expect(geo.longitude, 5.800003829500944);
        });
      });

      group('given barcode is a QR phone', () {
        test('test phone', () {
          final barcode = parser.parse(_phone);
          assert(barcode is BarcodePhone);
          expect(barcode.rawValue, _phone);

          final phone = barcode as BarcodePhone;

          expect(phone.number, '555-555-5555');
        });
      });

      group('given barcode is a QR SMS', () {
        test('test message', () {
          final barcode = parser.parse(_smsMessage);
          assert(barcode is BarcodeSms);
          expect(barcode.rawValue, _smsMessage);

          final sms = barcode as BarcodeSms;

          expect(sms.phoneNumber, null);
          expect(sms.message, 'A message without phone.');
        });
        test('test to', () {
          final barcode = parser.parse(_smsTo);
          assert(barcode is BarcodeSms);
          expect(barcode.rawValue, _smsTo);

          final sms = barcode as BarcodeSms;

          expect(sms.phoneNumber, '321654987');
          expect(sms.message, null);
        });
        test('test to long message semicolons', () {
          final barcode = parser.parse(_smsToLongMessageSemicolons);
          assert(barcode is BarcodeSms);
          expect(barcode.rawValue, _smsToLongMessageSemicolons);

          final sms = barcode as BarcodeSms;

          expect(sms.phoneNumber, '654987321');
          expect(
            sms.message,
            'This is a long message, with some symbols: here and there - just to check that everything works',
          );
        });
        test('test to message', () {
          final barcode = parser.parse(_smsToMessage);
          assert(barcode is BarcodeSms);
          expect(barcode.rawValue, _smsToMessage);

          final sms = barcode as BarcodeSms;

          expect(sms.phoneNumber, '666999777');
          expect(sms.message, 'content of the SMS');
        });
        test('test smsto: (lowercase)', () {
          final barcode = parser.parse(_smsToLowercase);
          assert(barcode is BarcodeSms);
          expect(barcode.rawValue, _smsToLowercase);

          final sms = barcode as BarcodeSms;

          expect(sms.phoneNumber, '666999777');
          expect(sms.message, 'message');
        });
      });

      group('given barcode is plain text', () {
        test('test long', () {
          final barcode = parser.parse(_textLong);
          assert(barcode is BarcodeText);
          expect(barcode.rawValue, _textLong);
        });
        test('test short', () {
          final barcode = parser.parse(_textShort);
          assert(barcode is BarcodeText);
          expect(barcode.rawValue, _textShort);
        });
      });

      group('given barcode is a QR URL', () {
        test('test long', () {
          final barcode = parser.parse(_urlLong);
          assert(barcode is BarcodeUrl);
          expect(barcode.rawValue, _urlLong);

          final url = barcode as BarcodeUrl;

          expect(url.url, _urlLong);
        });
        test('test short', () {
          final barcode = parser.parse(_urlShort);
          assert(barcode is BarcodeUrl);
          expect(barcode.rawValue, _urlShort);

          final url = barcode as BarcodeUrl;

          expect(url.url, _urlShort);
        });
      });

      group('given barcode is a QR WiFi', () {
        test('test open', () {
          final barcode = parser.parse(_wifiOpen);
          assert(barcode is BarcodeWifi);
          expect(barcode.rawValue, _wifiOpen);

          final wifi = barcode as BarcodeWifi;

          expect(wifi.ssid, 'NoneSsid');
          expect(wifi.password, null);
          expect(wifi.encryptionType, WifiEncryptionType.open);
        });
        test('test wep', () {
          final barcode = parser.parse(_wifiWep);
          assert(barcode is BarcodeWifi);
          expect(barcode.rawValue, _wifiWep);

          final wifi = barcode as BarcodeWifi;

          expect(wifi.ssid, 'WepSsid');
          expect(wifi.password, 'b8F6xd');
          expect(wifi.encryptionType, WifiEncryptionType.wep);
        });
        test('test wpa', () {
          final barcode = parser.parse(_wifiWpa);
          assert(barcode is BarcodeWifi);
          expect(barcode.rawValue, _wifiWpa);

          final wifi = barcode as BarcodeWifi;

          expect(wifi.ssid, 'WpaSsid');
          expect(wifi.password, 'suP¬rSecret8');
          expect(wifi.encryptionType, WifiEncryptionType.wpa);
        });
      });

      group('given barcode is a Whatsapp code', () {
        test('test simple', () {
          final barcode = parser.parse(_whatsappSimple);
          assert(barcode is BarcodeWhatsapp);
          expect(barcode.rawValue, _whatsappSimple);

          final wp = barcode as BarcodeWhatsapp;

          expect(wp.phoneNumber, '124681112');
          expect(wp.message, null);
        });
        test('test whatsapp with message', () {
          final barcode = parser.parse(_whatsappMessage);
          assert(barcode is BarcodeWhatsapp);
          expect(barcode.rawValue, _whatsappMessage);

          final wp = barcode as BarcodeWhatsapp;

          expect(wp.phoneNumber, '124681112');
          expect(wp.message, 'message to be delivered');
        });
        test('test whatsapp api', () {
          final barcode = parser.parse(_whatsappApi);
          assert(barcode is BarcodeWhatsapp);
          expect(barcode.rawValue, _whatsappApi);

          final wp = barcode as BarcodeWhatsapp;

          expect(wp.phoneNumber, '124681112');
          expect(wp.message, null);
        });
      });

      group('given barcode is a Twitter username link', () {
        test('test twitter', () {
          final barcode = parser.parse(_twitter);
          assert(barcode is BarcodeTwitter);
          expect(barcode.rawValue, _twitter);

          final twitter = barcode as BarcodeTwitter;

          expect(twitter.username, 'username');
        });
      });

      group('given barcode is an Instagram username link', () {
        test('test instagram', () {
          final barcode = parser.parse(_instagram);
          assert(barcode is BarcodeInstagram);
          expect(barcode.rawValue, _instagram);

          final instagram = barcode as BarcodeInstagram;

          expect(instagram.username, 'username');
        });
      });

      group('given barcode is a Linkedin username link', () {
        test('test linkedin', () {
          final barcode = parser.parse(_linkedin);
          assert(barcode is BarcodeLinkedin);
          expect(barcode.rawValue, _linkedin);

          final linkedin = barcode as BarcodeLinkedin;

          expect(linkedin.username, 'username');
        });
      });

      group('given barcode is a Facebook username link', () {
        test('test facebook', () {
          final barcode = parser.parse(_facebook);
          assert(barcode is BarcodeFacebook);
          expect(barcode.rawValue, _facebook);

          final facebook = barcode as BarcodeFacebook;

          expect(facebook.username, 'username');
        });
      });

      group('given barcode is a driver license', () {
        test('test driver license', () {
          final barcode = parser.parse(_driverLicense);
          assert(barcode is BarcodeDriverLicense);
          expect(barcode.rawValue, _driverLicense);

          final driverLicense = barcode as BarcodeDriverLicense;

          expect(driverLicense.addressCity, 'RICHMOND');
          expect(driverLicense.addressState, 'VA');
          expect(driverLicense.addressStreet, '2300 WEST BROAD STREET');
          expect(driverLicense.addressZip, '232690000');
          expect(driverLicense.birthDate, DateTime(1986, 6, 6));
          expect(driverLicense.documentType, 'DL');
          expect(driverLicense.expiryDate, DateTime(2024, 12, 10));
          expect(driverLicense.firstName, 'MICHAEL');
          expect(driverLicense.gender, 'M');
          expect(driverLicense.issueDate, DateTime(2019, 6, 6));
          expect(driverLicense.issuingCountry, 'USA');
          expect(driverLicense.lastName, 'SAMPLE');
          expect(driverLicense.middleName, 'JOHN');
          expect(driverLicense.licenseNumber, 'T64235789');
        });
      });
    });
  });
}
