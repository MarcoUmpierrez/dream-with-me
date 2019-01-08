import 'package:dreamwithme/models/xml_param.dart';
import 'package:xml/xml.dart';

class XmlStruct implements XmlParam {
  Map<String, XmlParam> items;
  XmlStruct() {
    this.items = Map<String, XmlParam>();
  }

  @override
  Map<String, XmlParam> getValue() {
    return this.items;
  }

  @override
  XmlElement getXmlValue() {   
    return XmlElement(XmlName('struct'), [], this._getXmlValues());
  }

  List<XmlElement> _getXmlValues() {
    List<XmlElement> list = [];
    this.items.forEach((String key, XmlParam value) {
      list.add(XmlElement(XmlName('member'), [], [
        XmlElement(XmlName('name'), [], [XmlText(key)]),
        XmlElement(XmlName('value'), [], [value.getXmlValue()])
      ]));
    });

    return list;
  }
}