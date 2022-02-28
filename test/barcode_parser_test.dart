import 'package:barcode_parser/barcode_parser.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BarcodeParser -', () {
    // ***************************** CONSTANTS ***************************** //

    const VCARD = '''BEGIN:VCARD
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

    const EMAIL_MAILTO_COMPLEX =
        'mailto:rec0@test.com,rec1@test.com,rec2@test.com?subject=Again the subject&cc=cc1@test.com,cc2@test.com&bcc=bcc1@test.com,bcc2@test.com,bcc3@test.com&body=Finally we have the message body';
    const EMAIL_MATMSG_SIMPLE =
        'MATMSG:TO:email@email.com;SUB:asunto;BODY:mensaje;;';
    const EMAIL_SMTP_SIMPLE =
        'SMTP:email@test.com:Subject of the message:Email body message';

    const VEVENT_START_END = '''BEGIN:VEVENT
DTSTART:20200213T104200
DTEND:20200213T114200
END:VEVENT
    ''';
    const VEVENT_TITLE_DESCRIPTION_START_END = '''
BEGIN:VEVENT
SUMMARY:Title of the event
DESCRIPTION:Some description
LOCATION:Australia
DTSTART:20200213T104200
DTEND:20200213T114200
END:VEVENT
    ''';

    const GEO_BUNKERS = 'geo:41.419290,2.161652,500';
    const GEO_LEEUWARDEN = 'geo:53.20065838148934,5.800003829500944,500';

    const PHONE = 'tel:555-555-5555';

    const SMS_MESSAGE = 'SMSTO::A message without phone.';
    const SMS_TO = 'SMSTO:321654987:';
    const SMS_TO_LONG_MESSAGE_SEMICOLONS =
        'SMSTO:654987321:This is a long message, with some symbols: here and there - just to check that everything works';
    const SMS_TO_MESSAGE = 'SMSTO:666999777:content of the SMS';

    const TEXT_LONG =
        'bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla';
    const TEXT_SHORT = 'sample text';

    const URL_SHORT = 'https://agilemanifesto.org/';
    const URL_LONG =
        'https://stackoverflow.com/questions/27465851/how-should-i-handle-very-very-long-url';

    const WIFI_OPEN = 'WIFI:S:NoneSsid;T:nopass;P:;;';
    const WIFI_WEP = 'WIFI:S:WepSsid;T:WEP;P:b8F6xd;;';
    const WIFI_WPA = 'WIFI:S:WpaSsid;T:WPA;P:suP¬rSecret8;;';

    const PRODUCT_ISBN = '9781234567897';
    const PRODUCT_EAN_8 = '95050003';
    const PRODUCT_UPC_A = '614141000036';
    const PRODUCT_UPC_E = '06141939';
    const PRODUCT_EAN_13 = '9501101530003';

    const _whatsappSimple = 'https://wa.me/124681112';
    const _whatsappMessage =
        'https://wa.me/124681112/?text=message%20to%20be%20delivered';
    const _whatsappApi = 'https://api.whatsapp.com/send?phone=124681112';

    const _twitter = 'https://twitter.com/username';

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
          final barcode = parser.parse(VCARD);
          assert(barcode is BarcodeContactInfo);
          expect(barcode.rawValue, VCARD);
        });
      });

      group('given barcode is a QR email', () {
        test('test mailto complex', () {
          final barcode = parser.parse(EMAIL_MAILTO_COMPLEX);
          assert(barcode is BarcodeEmail);
          expect(barcode.rawValue, EMAIL_MAILTO_COMPLEX);

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
          final barcode = parser.parse(EMAIL_MATMSG_SIMPLE);
          assert(barcode is BarcodeEmail);
          expect(barcode.rawValue, EMAIL_MATMSG_SIMPLE);

          final email = barcode as BarcodeEmail;

          expect(email.recipients[0], 'email@email.com');
          expect(email.subject, 'asunto');
          expect(email.body, 'mensaje');
        });
        test('test SMTP simple', () {
          final barcode = parser.parse(EMAIL_SMTP_SIMPLE);
          assert(barcode is BarcodeEmail);
          expect(barcode.rawValue, EMAIL_SMTP_SIMPLE);

          final email = barcode as BarcodeEmail;

          expect(email.recipients[0], 'email@test.com');
          expect(email.subject, 'Subject of the message');
          expect(email.body, 'Email body message');
        });
      });

      group('given barcode is a QR event', () {
        test('test start end', () {
          final barcode = parser.parse(VEVENT_START_END);
          assert(barcode is BarcodeCalendarEvent);
          expect(barcode.rawValue, VEVENT_START_END);
        });
        test('test title description start end', () {
          final barcode = parser.parse(VEVENT_TITLE_DESCRIPTION_START_END);
          assert(barcode is BarcodeCalendarEvent);
          expect(barcode.rawValue, VEVENT_TITLE_DESCRIPTION_START_END);
        });
      });

      group('given barcode is a product code', () {
        test('test ISBN', () {
          final barcode = parser.parse(PRODUCT_ISBN);
          assert(barcode is BarcodeProduct);
          expect(barcode.rawValue, PRODUCT_ISBN);

          final product = barcode as BarcodeProduct;

          expect(product.code, 9781234567897);
        });
        test('test EAN 8', () {
          final barcode = parser.parse(PRODUCT_EAN_8);
          assert(barcode is BarcodeProduct);
          expect(barcode.rawValue, PRODUCT_EAN_8);

          final product = barcode as BarcodeProduct;

          expect(product.code, 95050003);
        });
        test('test EAN 13', () {
          final barcode = parser.parse(PRODUCT_EAN_13);
          assert(barcode is BarcodeProduct);
          expect(barcode.rawValue, PRODUCT_EAN_13);

          final product = barcode as BarcodeProduct;

          expect(product.code, 9501101530003);
        });
        test('test UPC A', () {
          final barcode = parser.parse(PRODUCT_UPC_A);
          assert(barcode is BarcodeProduct);
          expect(barcode.rawValue, PRODUCT_UPC_A);

          final product = barcode as BarcodeProduct;

          expect(product.code, 614141000036);
        });
        test('test UPC E', () {
          final barcode = parser.parse(PRODUCT_UPC_E);
          assert(barcode is BarcodeProduct);
          expect(barcode.rawValue, PRODUCT_UPC_E);

          final product = barcode as BarcodeProduct;

          expect(product.code, 06141939);
        });
      });

      group('given barcode is a QR location', () {
        test('test bunkers', () {
          final barcode = parser.parse(GEO_BUNKERS);
          assert(barcode is BarcodeLocation);
          expect(barcode.rawValue, GEO_BUNKERS);

          final geo = barcode as BarcodeLocation;

          expect(geo.latitude, 41.419290);
          expect(geo.longitude, 2.161652);
        });

        test('test leeuwarden', () {
          final barcode = parser.parse(GEO_LEEUWARDEN);
          assert(barcode is BarcodeLocation);
          expect(barcode.rawValue, GEO_LEEUWARDEN);

          final geo = barcode as BarcodeLocation;

          expect(geo.latitude, 53.20065838148934);
          expect(geo.longitude, 5.800003829500944);
        });
      });

      group('given barcode is a QR phone', () {
        test('test phone', () {
          final barcode = parser.parse(PHONE);
          assert(barcode is BarcodePhone);
          expect(barcode.rawValue, PHONE);

          final phone = barcode as BarcodePhone;

          expect(phone.number, '555-555-5555');
        });
      });

      group('given barcode is a QR SMS', () {
        test('test message', () {
          final barcode = parser.parse(SMS_MESSAGE);
          assert(barcode is BarcodeSms);
          expect(barcode.rawValue, SMS_MESSAGE);

          final sms = barcode as BarcodeSms;

          expect(sms.phoneNumber, null);
          expect(sms.message, 'A message without phone.');
        });
        test('test to', () {
          final barcode = parser.parse(SMS_TO);
          assert(barcode is BarcodeSms);
          expect(barcode.rawValue, SMS_TO);

          final sms = barcode as BarcodeSms;

          expect(sms.phoneNumber, '321654987');
          expect(sms.message, null);
        });
        test('test to long message semicolons', () {
          final barcode = parser.parse(SMS_TO_LONG_MESSAGE_SEMICOLONS);
          assert(barcode is BarcodeSms);
          expect(barcode.rawValue, SMS_TO_LONG_MESSAGE_SEMICOLONS);

          final sms = barcode as BarcodeSms;

          expect(sms.phoneNumber, '654987321');
          expect(sms.message,
              'This is a long message, with some symbols: here and there - just to check that everything works');
        });
        test('test to message', () {
          final barcode = parser.parse(SMS_TO_MESSAGE);
          assert(barcode is BarcodeSms);
          expect(barcode.rawValue, SMS_TO_MESSAGE);

          final sms = barcode as BarcodeSms;

          expect(sms.phoneNumber, '666999777');
          expect(sms.message, 'content of the SMS');
        });
      });

      group('given barcode is plain text', () {
        test('test long', () {
          final barcode = parser.parse(TEXT_LONG);
          assert(barcode is BarcodeText);
          expect(barcode.rawValue, TEXT_LONG);
        });
        test('test short', () {
          final barcode = parser.parse(TEXT_SHORT);
          assert(barcode is BarcodeText);
          expect(barcode.rawValue, TEXT_SHORT);
        });
      });

      group('given barcode is a QR URL', () {
        test('test long', () {
          final barcode = parser.parse(URL_LONG);
          assert(barcode is BarcodeUrl);
          expect(barcode.rawValue, URL_LONG);

          final url = barcode as BarcodeUrl;

          expect(url.url, URL_LONG);
        });
        test('test short', () {
          final barcode = parser.parse(URL_SHORT);
          assert(barcode is BarcodeUrl);
          expect(barcode.rawValue, URL_SHORT);

          final url = barcode as BarcodeUrl;

          expect(url.url, URL_SHORT);
        });
      });

      group('given barcode is a QR WiFi', () {
        test('test open', () {
          final barcode = parser.parse(WIFI_OPEN);
          assert(barcode is BarcodeWifi);
          expect(barcode.rawValue, WIFI_OPEN);

          final wifi = barcode as BarcodeWifi;

          expect(wifi.ssid, 'NoneSsid');
          expect(wifi.password, null);
          expect(wifi.encryptionType, WifiEncryptionType.open);
        });
        test('test wep', () {
          final barcode = parser.parse(WIFI_WEP);
          assert(barcode is BarcodeWifi);
          expect(barcode.rawValue, WIFI_WEP);

          final wifi = barcode as BarcodeWifi;

          expect(wifi.ssid, 'WepSsid');
          expect(wifi.password, 'b8F6xd');
          expect(wifi.encryptionType, WifiEncryptionType.wep);
        });
        test('test wpa', () {
          final barcode = parser.parse(WIFI_WPA);
          assert(barcode is BarcodeWifi);
          expect(barcode.rawValue, WIFI_WPA);

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
    });
  });
}
