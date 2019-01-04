import 'package:dreamwithme/models/xml_param.dart';
import 'package:xml/xml.dart';

class XmlInt implements XmlParam {
  String value;
  int _value;
  XmlInt(value) {
    this.value = value;
    this._value = int.parse(value);
  }

  @override
  int getValue() {
    return this._value;
  }

  @override
  XmlElement getXmlValue() {   
    return XmlElement(XmlName('int'), [], [XmlText(this.value)]);
  }
}