import 'package:dreamwithme/models/xml_param.dart';
import 'package:xml/xml.dart';

class XmlArray implements XmlParam {
  List<Map<String, XmlParam>> items;
  XmlArray() {
    this.items = List<Map<String, XmlParam>>();
  }

  @override
  List<Map<String, XmlParam>> getValue() {
    return this.items;
  }

  @override
  XmlElement getXmlValue() {   
    // TODO: implement XmlElement for an array
    // return XmlElement(XmlName('array'), [], [XmlText(this.value)]);
    return null;
  }
}