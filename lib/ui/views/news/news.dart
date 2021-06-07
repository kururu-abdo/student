import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:student_side/app/services_provider.dart';
import 'package:student_side/app/user_provider.dart';
import 'package:student_side/model/event.dart';
import 'package:student_side/ui/views/main_event_details.dart';
import 'package:student_side/util/ui/app_colors.dart';
import 'package:provider/provider.dart';
class NewsFeed extends StatefulWidget {
  NewsFeed({Key key}) : super(key: key);

  @override
  _NewsFeedState createState() => _NewsFeedState();
}

class _NewsFeedState extends State<NewsFeed> with TickerProviderStateMixin {
  TabController tabController; 
      ScrollController tab1 = new ScrollController();

    ScrollController tab2 = new ScrollController();

 @override
 void initState() { 
   tabController= new TabController(length: 2, vsync: this);
   super.initState();
   
 }


  @override
  Widget build(BuildContext context) {
    var main_provider = Provider.of<ServiceProvider>(context);

    var user_provider = Provider.of<UserProvider>(context);




    return DefaultTabController(length: 2, 
      child: Scaffold(
         appBar: new AppBar(
           elevation: 0.0,
           backgroundColor: AppColors.primaryColor,
           leading: IconButton(icon: Icon(Icons.arrow_back_ios , color: Colors.black,), onPressed: (){
             Get.back();
           }),
         ),
         body:
         
         
          ListView(children: [
          Text('الاخبار' ,   style: Theme.of(context).textTheme.headline5,) ,
          SizedBox(height: 5.0,) ,
          Container(
              height: 150,
              child: CarouselSlider(
                options: CarouselOptions(
                  autoPlay: true,
                  autoPlayInterval: Duration(seconds: 4),
                ),
                items: [
                  'assets/images/slide1.webp',
                  'assets/images/slide2.webp',
                  'assets/images/slide3.webp',
                  'assets/images/slide4.webp',
                  'assets/images/slide5.jpeg'
                ].map((i) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.symmetric(horizontal: 5.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                            image: DecorationImage(image: AssetImage(i)  , fit: BoxFit.cover) , ),
                      );
                    },
                  );
                }).toList(),
              ),
            ) ,
            SizedBox(height: 15.0,) ,
            Container(
              height: 40.0,
              child:  TabBar(controller: tabController,
              isScrollable: true,
              indicatorColor: Color.fromARGB(255, 255, 202, 70),
              indicatorSize: TabBarIndicatorSize.label,
              labelStyle: TextStyle(color: Colors.black),
              tabs: <Widget>[
          
                Tab(
          
                    child: Text(
                      'أخبار الدفعة',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                 Tab(
                    child: Text(
                      'أخبار القسم',
                      style: TextStyle(color: Colors.black),
                    ),
                  )
              ],
            ), 
            ) ,
            SizedBox(height: 5.0,) ,
            Container(
              height: MediaQuery.of(context).size.height/2,
              child: TabBarView(
                controller: tabController,
            children: <Widget>[
          
          
          
           
          
          
          
          
            Padding(
                    padding: EdgeInsets.all(8.0),
                    child: FutureBuilder<List<Event>>(
                      future: main_provider.getEvents(user_provider.getUser()),
                      builder: (BuildContext context,
                          AsyncSnapshot<List<Event>> snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (!snapshot.hasData) {
                          return Center(
                            child: Text('no events yet'),
                          );
                        }
                        return ListView(
                          children: snapshot.data
                              .map(
                                (event) => Card(
                                  elevation: 3.0,
shape: RoundedRectangleBorder(
  borderRadius: BorderRadius.all(Radius.circular(15))
),


                                  margin: new EdgeInsets.symmetric(
                                      horizontal: 10.0, vertical: 6.0),
                                  child: ListTile(
                                    leading: ImageIcon(
                                        AssetImage('assets/images/news.png')),
                                    onTap: () {
                                      Get.to(MainEventDetails(event));
                                    },
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 20.0, vertical: 10.0),
                                    title: Text(
                                      event.title,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        );
                      },
                    ),
                  ),
             Padding(
                    padding: EdgeInsets.all(8.0),
                    child: FutureBuilder<List<Event>>(
                      future:
                          main_provider.getDeptEvents(user_provider.getUser()),
                      builder: (BuildContext context,
                          AsyncSnapshot<List<Event>> snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (!snapshot.hasData) {
                          return Center(
                            child: Text('no events yet'),
                          );
                        }
                        return ListView(
                          children: snapshot.data
                              .map(
                                (event) => Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15))),

                                  elevation: 3.0,
                                  margin: new EdgeInsets.symmetric(
                                      horizontal: 10.0, vertical: 6.0),
                                  child: ListTile(
                                    leading: ImageIcon(
                                        AssetImage('assets/images/news.png')),
                                    onTap: () {
                                      Get.to(MainEventDetails(event));
                                    },
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 20.0, vertical: 10.0),
                                    title: Text(
                                      event.title,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        );
                      },
                    ),
                  ),
          
            ],
          ),
            )
          
          
               ],),
      ),
    );
  }
}