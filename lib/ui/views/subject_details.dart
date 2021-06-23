import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:student_side/model/subject.dart';
import 'package:student_side/ui/views/event_details.dart';
import 'package:student_side/ui/views/lecture_disscusion.dart';
import 'package:extended_image/extended_image.dart';

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
                      color: Colors.black,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold
                    ) //TextStyle
                    ), //Text
                background: Image.asset(
                  'assets/images/sub1.png',
                  fit: BoxFit.cover,
                ) //Images.network
                ), //FlexibleSpaceBar
            expandedHeight: 230,
            backgroundColor: Colors.greenAccent[400],
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
 
                  return new ListView(
                    children:
                        snapshot.data.docs.map((DocumentSnapshot document) {
var data  =  document.data()  as Map<String, dynamic>;
return Container(
  
child: ListTile(
  leading:  Container(
    color: Color.fromARGB(255, 255, 239, 240),
    child: Center(child: Text("001"),),
  ),
  title: new Text(data['name']),),
);

      
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
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0)),
                              color: Colors.brown[400],
                              boxShadow: [
                                BoxShadow(blurRadius: 2.0, color: Colors.black),
                                BoxShadow(blurRadius: 2.0),
                                BoxShadow(blurRadius: 2.0),
                                BoxShadow(blurRadius: 2.0)
                              ]),
                          child: ListTile(
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
