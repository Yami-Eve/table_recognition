// To parse this JSON data, do
//
//     final recognitionModel = recognitionModelFromJson(jsonString);

import 'dart:convert';

RecognitionModel recognitionModelFromJson(String str) =>
    RecognitionModel.fromJson(json.decode(str));

String recognitionModelToJson(RecognitionModel data) =>
    json.encode(data.toJson());

class RecognitionModel {
  RecognitionModel({
    this.sid,
    this.prismVersion,
    this.prismWnum,
    this.prismWordsInfo,
    this.height,
    this.width,
    this.orgHeight,
    this.orgWidth,
    this.content,
  });

  String? sid;
  String? prismVersion;
  int? prismWnum;
  List<PrismWordsInfo>? prismWordsInfo;
  int? height;
  int? width;
  int? orgHeight;
  int? orgWidth;
  String? content;

  factory RecognitionModel.fromJson(Map<String, dynamic> json) =>
      RecognitionModel(
        sid: json["sid"],
        prismVersion: json["prism_version"],
        prismWnum: json["prism_wnum"],
        prismWordsInfo: List<PrismWordsInfo>.from(
            json["prism_wordsInfo"].map((x) => PrismWordsInfo.fromJson(x))),
        height: json["height"],
        width: json["width"],
        orgHeight: json["orgHeight"],
        orgWidth: json["orgWidth"],
        content: json["content"],
      );

  Map<String, dynamic> toJson() => {
        "sid": sid,
        "prism_version": prismVersion,
        "prism_wnum": prismWnum,
        "prism_wordsInfo":
            List<dynamic>.from(prismWordsInfo!.map((x) => x.toJson())),
        "height": height,
        "width": width,
        "orgHeight": orgHeight,
        "orgWidth": orgWidth,
        "content": content,
      };
}

class PrismWordsInfo {
  PrismWordsInfo({
    this.word,
    this.pos,
    this.direction,
    this.angle,
    this.x,
    this.y,
    this.width,
    this.height,
  });

  String? word;
  List<Po>? pos;
  int? direction;
  int? angle;
  int? x;
  int? y;
  int? width;
  int? height;

  factory PrismWordsInfo.fromJson(Map<String, dynamic> json) => PrismWordsInfo(
        word: json["word"],
        pos: List<Po>.from(json["pos"].map((x) => Po.fromJson(x))),
        direction: json["direction"],
        angle: json["angle"],
        x: json["x"],
        y: json["y"],
        width: json["width"],
        height: json["height"],
      );

  Map<String, dynamic> toJson() => {
        "word": word,
        "pos": List<dynamic>.from(pos!.map((x) => x.toJson())),
        "direction": direction,
        "angle": angle,
        "x": x,
        "y": y,
        "width": width,
        "height": height,
      };
}

class Po {
  Po({
    this.x,
    this.y,
  });

  int? x;
  int? y;

  factory Po.fromJson(Map<String, dynamic> json) => Po(
        x: json["x"],
        y: json["y"],
      );

  Map<String, dynamic> toJson() => {
        "x": x,
        "y": y,
      };
}
