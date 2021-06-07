import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:student_side/app/services_provider.dart';
import 'package:student_side/app/user_provider.dart';
import 'package:student_side/model/event.dart';
import 'package:student_side/ui/views/main_event_details.dart';

class Events extends StatefulWidget {
  @override
  _EventsState createState() => _EventsState();
}

class _EventsState extends State<Events>  with SingleTickerProviderStateMixin {

  TabController tabController; 


  @override
  void initState() { 
    super.initState();
    tabController = new TabController(length: 4, vsync: this);
  }
   @override
  Widget build(BuildContext context) {
   


    var main_provider = Provider.of<ServiceProvider>(context);

       var user_provider = Provider.of<UserProvider>(context);
    return 
     Scaffold(


       appBar: AppBar(
        actions: [
          IconButton(
              icon: Icon(FontAwesomeIcons.home),
              onPressed: () {
                Get.back();
              })
        ],
        centerTitle: true,
        title: Text('الاخبار'),
        bottom: TabBar(
          controller: tabController,
tabs: [

Tab(
  text: 'اخبار الدفعة',
) , 

Tab(
              text: 'اخبار القسم',
            ), 

Tab(
              text: 'اخبار المستوى',
            ), 

Tab(
              text: 'اخبار عامة',
            ), 

],


        ),
      ),
       body:   TabBarView(
         controller: tabController,
         children: [

        Padding(
            padding: EdgeInsets.all(8.0),
            child: FutureBuilder<List<Event>>(
              future: main_provider.getEvents(user_provider.getUser()),
              builder:
                  (BuildContext context, AsyncSnapshot<List<Event>> snapshot) {
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
                          elevation: 8.0,
                          margin: new EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 6.0),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.grey[500].withOpacity(0.5)),
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
                        ),
                      )
                      .toList(),
                );
              },
            ),
          ) ,

           Padding(
            padding: EdgeInsets.all(8.0),
            child: FutureBuilder<List<Event>>(
              future: main_provider.getDeptEvents(user_provider.getUser()),
              builder:
                  (BuildContext context, AsyncSnapshot<List<Event>> snapshot) {
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
                          elevation: 8.0,
                          margin: new EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 6.0),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.grey[500].withOpacity(0.5)),
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
                        ),
                      )
                      .toList(),
                );
              },
            ),
          ) ,


 Padding(
            padding: EdgeInsets.all(8.0),
            child: FutureBuilder<List<Event>>(
              future: main_provider.getYeartEvents(user_provider.getUser()),
              builder:
                  (BuildContext context, AsyncSnapshot<List<Event>> snapshot) {
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
                          elevation: 8.0,
                          margin: new EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 6.0),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.grey[500].withOpacity(0.5)),
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
                        ),
                      )
                      .toList(),
                );
              },
            ),
          ) ,
           Padding(
            padding: EdgeInsets.all(8.0),
            child: FutureBuilder<List<Event>>(
             future: main_provider.getAlltEvents(),
              builder:
                  (BuildContext context, AsyncSnapshot<List<Event>> snapshot) {
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
                          elevation: 8.0,
                          margin: new EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 6.0),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.grey[500].withOpacity(0.5)),
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
                        ),
                      )
                      .toList(),
                );
              },
            ),
          )




       ])
       
      
     );


  }
}