import 'package:dreamwithme/models/xml_param.dart';
import 'package:xml/xml.dart';

class XmlInt implements XmlParam {
  String type;
  String value;
  int _value;
  XmlInt(type, value) {
    this.type = type;
    this.value = value;
    this._value = int.parse(value);
  }

  @override
  int getValue() {
    return this._value;
  }

  @override
  XmlElement getXmlValue() {   
    return XmlElement(XmlName(this.type), [], [XmlText(this.value)]);
  }
}