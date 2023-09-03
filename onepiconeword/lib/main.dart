import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MaterialApp(
    home: Games(),
    debugShowCheckedModeBanner: false,
  ));
}

class Games extends StatefulWidget {
  @override
  State<Games> createState() => _GamesState();
}

class _GamesState extends State<Games> {
  bool status = false;
  List<String> Imagespathlist = [];
  String imagepath = '';
  List answerlist = [];
  List toplist = [];
  List bottomlist = [];
  List abcdlist = [];
  String speling = '';
  Map map = {};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initImages();
  }

  Future initImages() async {
    // >> To get paths you need these 2 lines
    final manifestContent = await rootBundle.loadString('AssetManifest.json');

    final Map<String, dynamic> manifestMap = json.decode(manifestContent);
    // >> To get paths you need these 2 lines

    final imagePaths = manifestMap.keys
        .where((String key) => key.contains('images/'))
        .where((String key) => key.contains('.webp'))
        .toList();

    setState(() {
      Imagespathlist = imagePaths;
    });

    int aa = Random().nextInt(Imagespathlist.length);
    imagepath = Imagespathlist[aa];
    // String imagepath = "images/almond.webp";
    // print(imagepath);
    // List<String> list =  imagepath.split("/");//[images, almond.webp]
    // print(list);
    // String s1 = list[1];
    // print(s1);
    // List<String>list2 = s1.split("\.");//[almond, webp]
    // print(list2);

    speling = imagepath.split("/")[1].split("\.")[0];
    answerlist = speling.split("");
    toplist = List.filled(answerlist.length, "");
    String abcd = "abcdefghijklmnopqrstuvwxyz";
    List abcdlist = abcd.split(
        ""); //[a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r, s, t, u, v, w, x, y, z]
    abcdlist.shuffle();
    bottomlist = abcdlist.getRange(0, 10 - answerlist.length).toList();
    bottomlist.addAll(answerlist);
    bottomlist.shuffle();
    status = true;
  }

  @override
  Widget build(BuildContext context) {
    return status
        ? Scaffold(
            body: Column(
              children: [
                Expanded(
                  flex: 4,
                  child: Container(
                    color: Colors.black45,
                    child: Center(child: Image.asset("${imagepath}")),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    // color: Colors.black12,

                    child: GridView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: answerlist.length,
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 1),
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            setState(() {
                              if(toplist[index]!=''){
                                bottomlist[map[index]]=toplist[index];
                                toplist[index]="";
                                print(toplist[index]);
                              }
                            });
                          },
                          child: Container(
                            height: 50,
                            width: 50,
                            margin: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: Colors.blueGrey,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(width: 1)),
                            child: Center(
                                child: Text("${toplist[index]}",
                                    style: TextStyle(
                                        fontSize: 30, color: Colors.white))),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Expanded(flex: 1,
                  child: Container(
                    // height: 40,
                    // width: 40,
                    child: GridView.builder(
                      itemCount: 10,
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2),
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            setState(() {
                              for(int i = 0;i < toplist.length ;i++ ){
                                if(toplist[i]==''){
                                  toplist[i]=bottomlist[index];
                                  bottomlist[index]='';
                                  map[i]=index;
                                  break;
                                }
                              }
                              if(listEquals(toplist, answerlist)){

                                print("win");

                              }
                            });
                          },
                          child: Container(
                            // height: 100,
                            // width: 100,
                           margin: EdgeInsets.all(10),
                           child: Center(child: Text(bottomlist[index],style: TextStyle(fontSize: 20))),
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(width: 2)
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                )
              ],
            ),
          )
        : CircularProgressIndicator();
  }
}
