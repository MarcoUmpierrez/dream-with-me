import 'dart:async';
import 'dart:convert';
import 'package:dreamwithme/models/xml_param.dart';
import 'package:dreamwithme/models/xml_params/xml_array.dart';
import 'package:http/http.dart';
import 'package:xml/xml.dart';

class XMLRPCClient {
  final String host = 'www.dreamwidth.org';
  final String path = '/interface/xmlrpc';
  final String methodUrl = 'LJ.XMLRPC';
  Client client;

  XMLRPCClient() {
    client = Client();
  }

  Future<Map<String, XmlParam>> xmlRpcRequest(String methodName, [Map<String, XmlParam> params]) async {
    final String body = this._generateXML('$methodUrl.$methodName', params).toXmlString();
    final Map<String, String> headers = <String, String>{'Content-Type': 'text/xml'};

    Response response = await client.post(
      'https://$host$path',
      headers: headers, 
      body: body, 
      encoding: utf8
    );

    if (response.statusCode == 200) {
      return this._decodeResponse(parse(response.body));
    } else {
      return new Future.error(response);
    }
  }

  XmlDocument _generateXML(String methodName, Map<String, XmlParam> params) {
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

  Map<String, XmlParam> _getXmlParam(XmlElement element) {
    XmlParam xmlParam;
    String key = element.findElements('name').first.text;
    element = element.findElements('value').first;
    element = element.children.first;
    String type = element.name.local;
    if (type == 'array') {
      xmlParam = XmlParam(type); 
    } else {
      xmlParam = XmlParam(type, element.text);
    }

    return {key: xmlParam};
  }

  Map<String, XmlParam> _decodeResponse(XmlDocument document) {
    Map<String, XmlParam> parameters = {};

    XmlElement element = document.findElements('methodResponse').first;
    element = element.findElements('params').first;
    element = element.findElements('param').first;    
    element = element.findElements('value').first;   
    element = element.findElements('struct').first;

    Iterable<XmlElement> members = element.findElements('member');
    if (members.isNotEmpty) {
      members.forEach((member) {
        Map<String, XmlParam> map = this._getXmlParam(member);

        // special treatment for entry array
        if (map.containsKey('entries')) {
          XmlArray array = map['entries'];            
          Iterable<XmlElement> structs = member.findAllElements('struct');

          structs.forEach((struct) {
            Iterable<XmlElement> arrayMembers = struct.findElements('member');
            Map<String, XmlParam> subMap = {};
            arrayMembers.forEach((arrayMember) {
              subMap.addAll(this._getXmlParam(arrayMember));
            });
            
            array.items.add(subMap);
          });
        }

        parameters.addAll(map);
      });

      return parameters;
    } else {
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
      return {};
    }
  }
}
