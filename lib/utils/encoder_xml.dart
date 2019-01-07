import 'package:dreamwithme/models/xml_param.dart';
import 'package:xml/xml.dart';

class EncoderXml {
  XmlDocument generateXML(String methodName, Map<String, XmlParam> params) {
    return XmlDocument([
      XmlProcessing('xml', 'version="1.0"'),
      XmlElement(XmlName('methodCall'), [], [
        XmlElement(XmlName('methodName'), [], [XmlText(methodName)]),
        XmlElement(XmlName('params'), [], [
          XmlElement(XmlName('param'), [], [
            XmlElement(XmlName('value'), [],
                [XmlElement(XmlName('struct'), [], this._createXMLParams(params))])
          ])
        ])
      ])
    ]);
  }

  List<XmlElement> _createXMLParams(Map<String, XmlParam> params) {
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