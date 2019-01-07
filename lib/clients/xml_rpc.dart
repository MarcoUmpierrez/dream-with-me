import 'dart:async';
import 'dart:convert';
import 'package:dreamwithme/models/xml_param.dart';
import 'package:dreamwithme/utils/decoder_xml.dart';
import 'package:http/http.dart';
import 'package:xml/xml.dart';

class XMLRPCClient {
  final String host = 'www.dreamwidth.org';
  final String path = '/interface/xmlrpc';
  final String methodUrl = 'LJ.XMLRPC';
  Client client;
  DecoderXml decoder;

  XMLRPCClient() {
    this.client = Client();
    this.decoder = DecoderXml();
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
      return this.decoder.decoderXml(parse(response.body));
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
}
