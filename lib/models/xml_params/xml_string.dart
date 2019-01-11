import 'package:dreamwithme/models/xml_param.dart';
import 'package:xml/xml.dart';

class XmlString implements XmlParam {
  String value;
  XmlString(String value) {
    this.value = value;
  }

  @override
  String getValue() {
    return this.value;
  }

  @override
  XmlElement getXmlValue() {   
    return XmlElement(XmlName('string'), [], [XmlText(this.value)]);
  }
}