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
    return XmlElement(XmlName('array'), [], [
      XmlElement(XmlName('data'), [], this._getXmlValues())
    ]);
  }

  List<XmlElement> _getXmlValues() {
    List<XmlElement> list = [];
    this.items.forEach((Map<String, XmlParam> members) {
      list.add(XmlElement(XmlName('value'), [], [
        XmlElement(XmlName('struct'), [], this._getXmlMembers(members))
      ]));
    });

    return list;
  }

  List<XmlElement> _getXmlMembers(Map<String, XmlParam> params) {
    List<XmlElement> memberList = [];
    if (params != null && params.isNotEmpty) {
      params.forEach((key, value) => memberList.add(XmlElement(XmlName('member'), [], [
                XmlElement(XmlName('name'), [], [XmlText(key)]),
                XmlElement(XmlName('value'), [], [value.getXmlValue()])
              ])));
    }

    return memberList;
  }
}