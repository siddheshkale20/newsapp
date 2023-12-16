import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'model.dart';
import 'package:http/http.dart';
import 'category.dart';
import 'news.dart';
class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController search= new TextEditingController();
  List<Model> modellist= <Model>[];
  List<Model> providerlist= <Model>[];
  List nav_items=["Top news","Politics","Finance","Technology","Sports","Health"];
  bool isLoading=true;
  getNewsByQuery(String query) async
  {
    int i=0;
    Map element;
    String url="https://newsapi.org/v2/everything?q=$query&from=2023-06-06&sortBy=publishedAt&apiKey=d74e8fafa1f74bf0963bf526d665f5c8";
    Response response=await get(Uri.parse(url));
    Map data= jsonDecode(response.body);
    setState(() {
      for(element in data["articles"]){
        try{
         i++;
        Model querymodel= new Model();
        querymodel= Model.fromMap(element);
        modellist.add(querymodel);
        setState(() {
          isLoading=false;
        });
        if(i>18)break;
        }catch(e){print(e);}
      };
    });
  }
  getNewsByprovider(String query) async
  {
    String url="https://newsapi.org/v2/everything?q=$query&from=2023-06-06&sortBy=publishedAt&apiKey=d74e8fafa1f74bf0963bf526d665f5c8";
    Response response=await get(Uri.parse(url));
    Map data= jsonDecode(response.body);
    setState(() {
      data["articles"].forEach((element){
        try{
        Model querymodel= new Model();
        querymodel= Model.fromMap(element);
        providerlist.add(querymodel);
        setState(() {
          isLoading=false;
        });
        }catch(e){print(e);}
      });
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getNewsByQuery("news");
    getNewsByprovider("india");
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("News",style: TextStyle(color: Colors.white),),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body:SingleChildScrollView(child: Column(
        children: [
          Container(
            height: 50,
            margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              color: Colors.black26,
            ),
            child: Row(
              children: <Widget>[
                GestureDetector(
                  onTap: (){
                    if(search.text.replaceAll(" ", "")=="")
                    {
                      print("blank");
                    }
                    else{
                      Navigator.push(context, MaterialPageRoute<String>(builder: (context)=>Category(query:search.text)) );
                    }
                  },
                  child: Container(
                    child:
                    Icon(Icons.search,color: Colors.white,),padding: EdgeInsets.fromLTRB(15, 0, 7, 0),),
                ),
                Expanded(
                  child: TextField(
                    controller: search,
                    textInputAction: TextInputAction.search,
                    onSubmitted: (value){
                      if(value=="")int t=0;
                      else
                      Navigator.push(context, MaterialPageRoute<String>(builder: (context)=>Category(query:search.text)) );
                    },
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Search News...",
                        hintStyle: TextStyle(color: Colors.white60,fontWeight: FontWeight.w400)
                    ),
                  ),)
              ],
            ),
          ),
          Container(
            height: 50,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: nav_items.length,
                itemBuilder: (context,index){
                  return InkWell(
                    onTap: ()
                    {
                      Navigator.push(context,MaterialPageRoute(builder: (context)=>Category(query: nav_items[index])));
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
                      margin: EdgeInsets.symmetric(horizontal: 5),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child:Center(
                        child: Text(nav_items[index],style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                        ),),
                      ),
                    ),
                  );
            }),
          ),
          CarouselSlider(items:providerlist.map((item)
          {
            return Builder(builder: (BuildContext context){
              try{
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 5,vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: InkWell(
                  onTap: ()
                  {
                    Navigator.push(context, MaterialPageRoute(builder:(context)=>ViewNews(item.url)));
                  },
                  child: Card(
                      elevation: 1.0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)
                      ),
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.network(item.img,
                                fit: BoxFit.cover,
                                width:double.infinity,
                                height:250),
                          ),
                          Positioned(
                              left: 0,
                              right: 0,
                              bottom: 0,
                              child:Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                      gradient: LinearGradient(
                                          colors: [
                                            Colors.black12.withOpacity(0.1),
                                            Colors.black87,
                                          ],
                                          begin: Alignment.topCenter,
                                          end:  Alignment.bottomCenter
                                      )
                                  ),
                                  padding: EdgeInsets.symmetric(vertical: 7,horizontal: 10),
                                  child: Text(item.head,style: TextStyle(fontSize: 7,color: Colors.white),),)
                          ),
                        ],
                      )
                  ),
                ),
              );
          }catch(e){print(e);return Container();}
            });
          }).toList() , options: CarouselOptions(
            height: 200,
            autoPlay: true,
            enlargeCenterPage: true,
          ), ),
          Column(
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(20, 20, 0, 10),
                child: Row(
                  mainAxisAlignment:  MainAxisAlignment.start,
                  children: [
                    Text("LATEST NEWS",style:TextStyle(fontWeight: FontWeight.bold),),
                  ],
                ),
              ),
              isLoading ? CircularProgressIndicator(color: Colors.blue,):ListView.builder(
                physics:  NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: modellist.length,
                  itemBuilder: (context,index){
                  try{
                  return Container(

                    margin: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>ViewNews(modellist[index].url)));
                      },
                      child:Card(
                      elevation: 1.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)
                      ),
                      child: Stack(
                        children: [
                          ClipRRect(
                             borderRadius: BorderRadius.circular(20),
                              child: Image.network(modellist[index].img,
                                  fit: BoxFit.cover,
                                  width:double.infinity,
                                  height:250),
                          ),
                          Positioned(
                            left: 0,
                              right: 0,
                              bottom: 0,
                              child:Container(
                                 decoration: BoxDecoration(
                                   borderRadius: BorderRadius.circular(20),
                                   gradient: LinearGradient(
                                     colors: [
                                       Colors.black12.withOpacity(0.1),
                                       Colors.black87,
                                     ],
                                     begin: Alignment.topCenter,
                                     end:  Alignment.bottomCenter
                                   )
                                 ),
                                  padding: EdgeInsets.symmetric(vertical: 7,horizontal: 10),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(modellist[index].head,style: TextStyle(color: Colors.white,fontSize: 10),),
                                      Text(modellist[index].des.length>50 ? "${modellist[index].des.substring(0,55 )}....":modellist[index].des,style: TextStyle(color: Colors.white70,fontSize: 7),),
                                    ],
                                  ),)
                          ),
                        ],
                      )
                    ),),
                  );
                  }catch(e){print(e);return Container();}
                  }),
              isLoading ? CircularProgressIndicator(color: Colors.white,):Container(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(onPressed: (){
                      Navigator.push(context, MaterialPageRoute<String>(builder: (context)=>Category(query:city)) );
                    }, child: Text("Show More"))
                  ],
                ),
              )
            ],
          )
        ],
      ),
    ));
  }
  final List items=["Technology","Politics","Health","Finance"];
  final random= new Random();
  late String city=items[random.nextInt(items.length)];
}
