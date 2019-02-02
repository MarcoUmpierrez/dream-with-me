
import 'package:dreamwithme/models/xml_params/xml_array.dart';
import 'package:dreamwithme/models/xml_params/xml_base64.dart';
import 'package:dreamwithme/models/xml_params/xml_int.dart';
import 'package:dreamwithme/models/xml_params/xml_string.dart';
import 'package:dreamwithme/models/xml_params/xml_struct.dart';

class XmlParam {
  factory XmlParam(String type, [String value]) {
    assert(type != null && type.isNotEmpty);
    
    switch (type) {
      case 'string':
        return XmlString(value);
      case 'int':
        return XmlInt(value);
      case 'base64':
        return XmlBase64(value);
      case 'array':
        return XmlArray();
      case 'struct':
        return XmlStruct();
      default:
        print('Type "$type" no implemented as XML parameter.');
        return null;
    }
  }

  dynamic getValue() {}
  dynamic getXmlValue() {}    
}









