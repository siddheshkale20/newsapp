
import 'dart:convert';
import 'package:flutter/material.dart';
import 'model.dart';
import 'package:http/http.dart';
import 'news.dart';
class Category extends StatefulWidget {
   late String query;
   Category({required this.query});
  @override
  State<Category> createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  List<Model> modellist= <Model>[];
  bool isLoading=true;
  getNewsByQuery(String query) async
  {
    late String url;
    Map element;
    int i=0;
    if(query=="Top news")
      {
        url="https://newsapi.org/v2/everything?q=news&from=2023-06-06&sortBy=publishedAt&apiKey=d74e8fafa1f74bf0963bf526d665f5c8";
      }
    else{
    url="https://newsapi.org/v2/everything?q=$query&from=2023-06-06&sortBy=publishedAt&apiKey=d74e8fafa1f74bf0963bf526d665f5c8";}
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
        if(i>10){break;}
        }catch(e){print(e);}
      }
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getNewsByQuery(widget.query);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("News"),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body:SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(20, 20, 0, 10),
                child: Row(
                  mainAxisAlignment:  MainAxisAlignment.start,
                  children: [
                    Text(widget.query,style:TextStyle(fontWeight: FontWeight.bold),),
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
                        child: Card(
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
                        ),
                      ),
                    );
                    }catch(e){print(e);return Container();}
                  }),

            ],
          ),
        ),
      ),
    );
  }
}
