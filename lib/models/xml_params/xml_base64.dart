import 'package:dreamwithme/models/xml_param.dart';
import 'package:xml/xml.dart';
import 'dart:convert';

class XmlBase64 implements XmlParam {
  String value;
  XmlBase64(value) {
    this.value = value;
  }

  @override
  String getValue() {
    return utf8.decode(base64.decode(this.value));
  }

  @override
  XmlElement getXmlValue() {   
    return XmlElement(XmlName('base64'), [], [XmlText(this.value)]);
  }
}