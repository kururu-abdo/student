import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:student_side/model/subject.dart';
import 'package:student_side/ui/views/event_details.dart';
import 'package:student_side/ui/views/lecture_disscusion.dart';
import 'package:student_side/util/ui/app_colors.dart';

class SubjectDetails extends StatefulWidget {
  final ClassSubject subject;
  SubjectDetails(this.subject);


  @override
  _SubjectDetailsState createState() => _SubjectDetailsState();
}

class _SubjectDetailsState extends State<SubjectDetails>
    with SingleTickerProviderStateMixin {
  TabController tabController;
  CollectionReference users = FirebaseFirestore.instance.collection('lectures');
  @override
  void initState() {
    super.initState();
    tabController = new TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference users =
        FirebaseFirestore.instance.collection('lectures');
    CollectionReference events =
        FirebaseFirestore.instance.collection('subject-events');
    return SafeArea(
        child: Material(
      child: Scaffold(
        body: CustomScrollView(slivers: <Widget>[
          SliverAppBar(
            leading: IconButton(onPressed: (){
              Navigator.of(context).pop();
            }, icon: new Icon(Icons.arrow_back   ,  color: Colors.black,)),
            snap: false,
            pinned: true,
            floating: true,
            flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                title: Text("${widget.subject.name}",
                    style: TextStyle(
                      color:  Colors.black,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold
                    ) //TextStyle
                    ), //Text
                background: Image.asset(
                  'assets/images/sub1.png',
                  fit: BoxFit.cover,
                ) //Images.network
                ), //FlexibleSpaceBar
            expandedHeight: 200,
        
          ),
          SliverFillRemaining(
              child: Scaffold(
            appBar: TabBar(controller: tabController, tabs: <Widget>[
              Tab(
                  child: Text(
                "المحاضرات",
                style: TextStyle(color: Colors.black),
              )),
              Tab(
                  child: Text(
                "الإعلانات",
                style: TextStyle(color: Colors.black),
              )),
            ]),
            body: TabBarView(controller: tabController, children: [
             
              StreamBuilder<QuerySnapshot>(
                stream: users
                    .where('subject_id', isEqualTo: widget.subject.id)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {

                  if (snapshot.hasError) {
                    return Text('Something went wrong');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {


            
                    return Text("loading.....");


                  }
return ListView(
                      children: snapshot.data.docs
                          .asMap()
                          .map((
                            i,
                            DocumentSnapshot document,
                          ) {
                           
                            return MapEntry(
                                i,
                                Container(
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (_) => LectureDisscusion(
                                                  document.data())));
                                    },
                                    child:
                                    
                                     Card(
                                        margin: EdgeInsets.only(bottom: 8.0),
                                        elevation: 2.0,
                                        // color: Colors.yellow,
                                        child: new ListTile(
                                          leading: Container(
                                              height: 40,
                                              width: 40,
                                              child: Center(
                                                child: Text((i + 1).toString(),
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold)),
                                              ),
                                              decoration: BoxDecoration(
                                                  color: Colors.blueGrey,
                                                  shape: BoxShape.circle)),
                                          title: new Text(
                                            document.get("name"),
                                            style: TextStyle(
                                                color: Color(0xFF0336FE)),
                                          ),
                                        ),
                                      ),
                                    ),
                                
                                ));
                          })
                          .values
                          .toList());
                  return new ListView(
                    children:
                        snapshot.data.docs.map((DocumentSnapshot document) {
var data  =  document.data()  as Map<String, dynamic>;
return ListTile(
  leading:  Container(
    color: Color.fromARGB(255, 255, 239, 240),
    child: Center(child: Text("001"),),
  ),
  title: new Text(data['name']),);

      
                    }).toList(),
                  );
                },
              ),
              StreamBuilder<QuerySnapshot>(
                stream: events
                    .where('subject_id', isEqualTo: widget.subject.id)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('error');
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Text('waiting...');
                  }
                  return ListView.builder(
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => Material(
                                  child: EventDeitals(
                                      snapshot.data.docs[index].data()))));
                        },

                        child: Card(
                          elevation: 5.0,
                          margin: EdgeInsets.all(10.0),
                          child: ListTile(
                            trailing: Container(
                              height: 40,
                              width: 40,
                              color: Colors.green,
                              child: Center(child:Text((index+1).toString())),),
                            title: Text(snapshot.data.docs[index]['name']),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ]),
          ))
        ]),
      ),
    ));
  }
}
