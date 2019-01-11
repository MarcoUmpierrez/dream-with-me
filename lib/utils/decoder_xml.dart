import 'package:dreamwithme/models/xml_param.dart';
import 'package:dreamwithme/models/xml_params/xml_struct.dart';
import 'package:dreamwithme/models/xml_params/xml_array.dart';
import 'package:xml/xml.dart';

class DecoderXml {
  Map<String, XmlParam> decoderXml(XmlDocument document) {
    XmlElement element = this._getFirstXmlElement(document);
    if (element.name.local == 'methodResponse') {
      while (element.name.local != 'struct') {
        element = this._getFirstXmlElement(element);
      }

      return this._getMembers(element);
    }

    return null;

    // TODO: handle fault responses
    // int faultCode;
    // String faultString;
    // final members = response
    //     .findElements('fault')
    //     .first
    //     .findElements('value')
    //     .first
    //     .findElements('struct')
    //     .first
    //     .findElements('member');
    // for (final member in members) {
    //   final name = member.findElements('name').first.text;
    //   final valueElt = member.findElements('value').first;
    //   final elt = getValueContent(valueElt);
    //   final value = decode(elt, decodeCodecs);
    //   if (name == 'faultCode') {
    //     faultCode = value as int;
    //   } else if (name == 'faultString') {
    //     faultString = value as String;
    //   }
    // }
    // return new Fault(faultCode, faultString);
  }

  XmlElement _getFirstXmlElement(XmlNode node) { 
    if (node.firstChild == null) {
      return null;
    }

    XmlNode element = node.firstChild;
    while (element.nodeType != XmlNodeType.ELEMENT) {
      element = element.nextSibling;
      if (element == null) {
        return null;
      }
    }

    return element;
  }  

  XmlElement _getLastXmlElement(XmlNode node) {    
    if (node.lastChild == null) {
      return null;
    }

    XmlNode element = node.lastChild;
    while (element.nodeType != XmlNodeType.ELEMENT) {
      element = element.previousSibling;
      if (element == null) {
        return null;
      }
    }

    return element;
  }

  String _getMemberType(XmlElement member) {
    XmlElement element = this._getLastXmlElement(member);
    if (element.firstChild == null) {
      return null;
    }

    return this._getFirstXmlElement(element).name.local;
  }

  String _getMemberName(XmlElement member) {
    return this._getFirstXmlElement(member).text;
  }

  List<Map<String, XmlParam>> _getArrayMembers(XmlElement array) {
    List<Map<String, XmlParam>> items = [];

    Iterable<XmlElement> values = this._getFirstXmlElement(array).findElements('value');
    values.forEach((XmlElement value) {
      items.add(this._getMembers(this._getFirstXmlElement(value)));
    });

    return items;
  }

  Map<String, XmlParam> _getMembers(XmlElement element) {  
    Map<String, XmlParam> parameters = {};
    Iterable<XmlElement> members = element.findElements('member');
    members.forEach((XmlElement member) {
      String type = this._getMemberType(member);
      XmlElement memberValue = this._getFirstXmlElement(this._getLastXmlElement(member));
      if (type == null) {
        parameters.addAll({this._getMemberName(member): null});
      } else if (type == 'struct') {
        XmlStruct struct = XmlStruct();
        struct.items.addAll(this._getMembers(memberValue));
        parameters.addAll({this._getMemberName(member):struct});
      } else if (type == 'array') {
        XmlArray array = XmlArray();
        array.items.addAll(this._getArrayMembers(memberValue));
        parameters.addAll({this._getMemberName(member):array});
      } else {
        parameters.addAll({this._getMemberName(member):XmlParam(type, memberValue.text)});
      }
    });

    return parameters;
  }
}
