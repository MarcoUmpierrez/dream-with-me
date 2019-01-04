
import 'package:dreamwithme/models/xml_params/xml_array.dart';
import 'package:dreamwithme/models/xml_params/xml_base64.dart';
import 'package:dreamwithme/models/xml_params/xml_int.dart';
import 'package:dreamwithme/models/xml_params/xml_string.dart';

class XmlParam {
  factory XmlParam(String type, [String value]) {
    switch (type) {
      case 'string':
        return XmlString(type, value);
      case 'int':
        return XmlInt(type, value);
      case 'base64':
        return XmlBase64(type, value);
      case 'array':
        return XmlArray(type);
      default:
        print('Type "$type" no implemented as XML parameter.');
        return null;
    }
  }

  dynamic getValue() {}
  dynamic getXmlValue() {}    
}









