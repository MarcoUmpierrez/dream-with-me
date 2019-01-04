import 'package:dreamwithme/models/xml_param.dart';
import 'package:xml/xml.dart';

class XmlArray implements XmlParam {
  String type;
  List<Map<String, XmlParam>> items;
  XmlArray(String type) {
    this.type = type;
    this.items = List<Map<String, XmlParam>>();
  }

  @override
  List<Map<String, XmlParam>> getValue() {
    return this.items;
  }

  @override
  XmlElement getXmlValue() {   
    // TODO: implement XmlElement for an array
    // return XmlElement(XmlName(this.type), [], [XmlText(this.value)]);
    return null;
  }
}