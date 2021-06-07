import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:student_side/util/ui/app_colors.dart';

class NewsFeed extends StatefulWidget {
  NewsFeed({Key key}) : super(key: key);

  @override
  _NewsFeedState createState() => _NewsFeedState();
}

class _NewsFeedState extends State<NewsFeed> with TickerProviderStateMixin {
  TabController tabController; 
 @override
 void initState() { 
   tabController= new TabController(length: 3, vsync: this);
   super.initState();
   
 }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: new AppBar(
         elevation: 0.0,
         backgroundColor: AppColors.primaryColor,
         leading: IconButton(icon: Icon(Icons.arrow_back_ios , color: Colors.black,), onPressed: (){
           Get.back();
         }),
       ),
       body: ListView(children: [
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
            indicatorColor: Color.fromARGB(255, 255, 202, 70),
      indicatorSize: TabBarIndicatorSize.label,
            labelStyle: TextStyle(color: Colors.black),
            tabs: <Widget>[
              Tab( 
                
                
                child: Text('أخبار الجامعة' , style: TextStyle(color: Colors.black),),),
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
            height: MediaQuery.of(context).size.height,
            child: TabBarView(
              controller: tabController,
          children: <Widget>[
            Center(child: Text("اخبار الدفعة")),
            Center(child: Text("اخبار القسم")),
            Center(child: Text("اخبار الجامعة")),
          ],
        ),
          )


       ],),
    );
  }
}