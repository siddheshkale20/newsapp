import 'package:flutter/material.dart';
class Model
{
  late String des;
  late String head;
  late String img;
  late String url;
  Model({this.head="News Headline",this.des="Some News",this.url="Some url",this.img="Some img"});
  factory Model.fromMap(Map news)
  {
    return Model(
    head : news["title"],
    des:  news["description"],
    img: news["urlToImage"],
    url: news["url"],
    );
  }
}
