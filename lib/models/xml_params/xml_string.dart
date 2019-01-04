import 'package:dreamwithme/models/xml_param.dart';
import 'package:xml/xml.dart';

class XmlString implements XmlParam {
  String type;
  String value;
  XmlString(type, value) {
    this.type = type;
    this.value = value;
  }

  @override
  String getValue() {
    return this.value;
  }

  @override
  XmlElement getXmlValue() {   
    return XmlElement(XmlName(this.type), [], [XmlText(this.value)]);
  }
}