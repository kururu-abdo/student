import 'dart:convert';
import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:page_transition/page_transition.dart';

import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:load/load.dart';
import 'package:student_side/app/animated_container.dart';
import 'package:student_side/app/services_provider.dart';
import 'package:student_side/app/subject_bloc.dart';
import 'package:student_side/app/user_provider.dart';
import 'package:student_side/model/day.dart';
import 'package:student_side/model/department.dart';
import 'package:student_side/model/level.dart';
import 'package:student_side/model/semester.dart';
import 'package:student_side/model/student.dart';
import 'package:student_side/model/subject.dart';
import 'package:student_side/ui/views/events.dart';
import 'package:student_side/ui/views/home/consults/consults.dart';
import 'package:student_side/ui/views/home/consults/new_consult.dart';
import 'package:student_side/ui/views/home/main_drawer.dart';
import 'package:student_side/ui/views/home/subjects/subject_list.dart';
import 'package:student_side/ui/views/home/subjects/subject_widget.dart';
import 'package:student_side/ui/views/logout/logout_view.dart';
import 'package:student_side/ui/views/teachers.dart';
import 'package:student_side/ui/views/website.dart';
import 'package:student_side/ui/views/welcome_screen.dart';
import 'package:student_side/ui/views/widgets/about_college.dart';
import 'package:student_side/util/constants.dart';
import 'package:student_side/util/fcm_init.dart';
import 'package:student_side/ui/views/courses_page.dart';
import 'package:student_side/util/local_notifications.dart';
import 'package:student_side/util/ui/app_colors.dart';
import 'package:student_side/util/ui/notifcatin_page.dart';
import 'package:tinycolor/tinycolor.dart';

import '../courses_page.dart';
import '../profile_page.dart';

class HomeView extends StatefulWidget {
  final String user_id;

  const HomeView({this.user_id});
  @override
  State<StatefulWidget> createState() {
    return _State();
  }
}

class _State extends State<HomeView> {
   final GlobalKey<ScaffoldState> _scflKey = new GlobalKey<ScaffoldState>(); 
  String image;
  String name;
  String email;
  Department dept;
  Level level;
  @override
  void initState() {
    super.initState();
        _pageController = PageController();

    fetchStudnet();
//fetch_semesters();

    print(getStorage.read('student'));

    print(getStorage.read('student').runtimeType);

    FCMConfig.fcmConfig();
    subscribe();

    fetch_semesters();
    fetch_subjects();
    getDaysOfWeek().then((value){
setState(() {
  selectedDay=DAYS[0];
});

    });

    // debugPrint(selectedDay.name);
  }

  List subjects = [];
  fetch_subjects() async {
    var future = await showLoadingDialog();

    FirebaseFirestore firestore = FirebaseFirestore.instance;

    var level = firestore
        .collection('subject')
        .where('level', isEqualTo: this.level.toJson());

    var fetchedSemester = await level.get();

    Iterable I = fetchedSemester.docs;
    print(
        'dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd');
    setState(() {
      subjects = I;
      // semsters =   I.map((e) => Semester.fromJson(e.data()) ).toList();
    });

    future.dismiss();
  }

  subscribe() {
    var data = getStorage.read('student');
    var student = Student.fromJson(json.decode(data));

    FCMConfig.subscripeToTopic(
        "${student.department.dept_code}${student.level.id}");
    FCMConfig.subscripeToTopic("level${student.level.id.toString()}");
    FCMConfig.subscripeToTopic("${student.department.dept_code}");

    FCMConfig.subscripeToTopic("${student.id_number.toString()}");
    FCMConfig.subscripeToTopic("general");
  }

  List<Semester> semsters = [];
  Semester semester;
  Map selectedDay;
  int _currentIndex = 0;
  PageController _pageController;
  fetch_semesters() async {
    var future = await showLoadingDialog();

    FirebaseFirestore firestore = FirebaseFirestore.instance;

    var level = firestore.collection('semester');

    var fetchedSemester = await level.get();

    Iterable I = fetchedSemester.docs;
    print(
        'dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd');
    setState(() {
      semsters = I.map((e) => Semester.fromJson(e.data())).toList();
    });

    future.dismiss();
  }

  fetchStudnet() async {
    var data = getStorage.read('student');
    var student = Student.fromJson(json.decode(data));
// var user_image =   await   downloadURLExample(student.profile_image)??''  ;
    setState(() {
      // image= user_image;
      name = student.name;

      this.dept = Department.fromJson(student.department.toJson());
      this.level = Level.fromJson(student.level.toJson());
    });
  }

  List<Day> days=[];
String getformattedToday(){
  DateTime now = DateTime.now();
    String formattedDate = DateFormat('MMM-dd – kk:mm' ).format(now);


return formattedDate;
}
bool isToday(int index){
  var now = DateTime.now().weekday;
  return index==now;
}

getDaysOfWeek() async {
      var future = await showLoadingDialog();
 FirebaseFirestore firestore = FirebaseFirestore.instance;

    var days = firestore.collection('days');

    var fetchedDays = await days.get();

    Iterable I = fetchedDays.docs;
    print(
        'dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd');
    setState(() {
      this.days = I.map((e) => Day.fromJson(e.data())).toList();
    });

    future.dismiss();
}

String getDateOfTheDay(int day) {
    var monday = 1;
    var now = new DateTime.now();

    while (now.weekday != monday) {
      now = now.subtract(new Duration(days: 1));
    }
    var dayOfWeek = day;
    DateTime date = DateTime.now();
    var lastMonday = date.subtract(Duration(days: date.weekday - dayOfWeek));
// .toIso8601String();
    final DateFormat formatter = DateFormat('M/dd');
    final formattedDate = formatter.format(lastMonday);
        return formattedDate;
  }

  bool      isShow=false;

  @override
  Widget build(BuildContext context) {
    var animProvider = Provider.of<AnimContainer>(context);
    var studentProvider = Provider.of<UserProvider>(context);
    var rotate = Provider.of<AnimContainer>(context).rotateY;
    var serviceProvider = Provider.of<ServiceProvider>(context);
    var subjectProvider = Provider.of<SubjectProvider>(context);

    return Scaffold(
      key: _scflKey,
        backgroundColor: Color.fromARGB(255, 254, 255, 255),
        drawer :MainDrawer(),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [
              SizedBox(
                height: 10.0,
              ),
              Container(
                height: 30.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset(
                      "assets/images/karari.png",
                      height: 30,
                    ),
                    Row(

                      children: [

                        IconButton(
                            icon: Icon(Icons.notifications), onPressed: () {


Get.to(NotificationPage({})  );

                            }),

                            
                        IconButton(
                            icon: Icon(Icons.menu_outlined), onPressed: () {
 _scflKey.currentState.openDrawer(); 

                            }),
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 20.0,
              ),

Center(child: Text('مرحبا  ,   $name' ,   style: TextStyle(fontWeight: FontWeight.bold , fontSize: 15),)) ,
 SizedBox(
                height: 10.0,
              ),

              Text(
                'الجدول',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  
                  Text(getformattedToday()), Icon(Icons.calendar_today_outlined)
                  ],
              ),
              SizedBox(
                height: 5.0,
              ),
              Container(
                height: 1,
                width: double.infinity,
                color: Colors.grey,
              ),
              SizedBox(
                height: 30.0,
              ),
              Container(
                height: 100,
                width: double.infinity,
                child: ListView.builder(
                  itemCount: DAYS.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                 


                    // if (isToday(days[index].id)) {
                    //   selectedDay=days[index];
                    // }

                    
                    return InkWell(
                      onTap: () async{
                                                                          selectedDay = DAYS[index];

                        setState(() {
                                                  selectedDay = DAYS[index];
isShow=true;
                        });


await serviceProvider.getTimeTable(studentProvider.getUser(), selectedDay);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                            // mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(DAYS[index]['name']),
                              // Container(
                              //   height: 20,
                              //   width: 30,
                              //   decoration: BoxDecoration(
                              //       color:
                              //        isToday (DAYS[index]['id']) ? Colors.black : Colors.white,
                              //       borderRadius:
                              //           BorderRadius.all(Radius.circular(10))),
                              //   child: Text(
                              //    getDateOfTheDay(days[index].id),
                              //     style: TextStyle(
                              //         color:      isToday(days[index].id)
                              //             ? Colors.white
                              //             : Colors.black),
                              //   ),
                              // ),
                              Icon(Icons.more_horiz)
                            ]),
                      ),
                    );
                  },
                ),
              ),
              Visibility(visible: isShow, child: Container(
   height: MediaQuery.of(context).size.height/3 ,


   child: FutureBuilder<List<Map>>(
     future: serviceProvider.getTimeTable(studentProvider.getUser(), selectedDay),
     builder: (BuildContext context, AsyncSnapshot<List<Map>> snapshot) {

if (snapshot.connectionState ==ConnectionState.done) {
if (snapshot.hasData  &&  snapshot.data.length>0) {
  return  ListView.builder(
    itemCount: snapshot.data.length,
    itemBuilder: (BuildContext context, int index) {
    return   Card(
      child: ListTile(title:  Text(snapshot.data[index]["subject"]['name']) ,
      subtitle: Row(children: [
        Text(
                                          snapshot.data[index]['from']) ,
 Text("---"),

 Text(snapshot.data[index]['to']),


      ],),
      leading: Image.asset('assets/images/subject.png'),
trailing: Text(snapshot.data[index]['hall'] ,   overflow: TextOverflow.ellipsis,) ,      
         ),
    ) ; 
   },
  );
} 
return  Center(
                          child: Text('لا توجد محاضرات في هذا اليوم '),
                        );
}
return Center(child: CircularProgressIndicator(),);

     },
   ),

              )),
              SizedBox(
                height: 20.0,
              ),
              Container(
                height: 30.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('المواد',
                        style: TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.bold)),
                    InkWell(
                      onTap: () {

Navigator.of(context).push(
 PageTransition(
                          type: PageTransitionType.fade, child: Subjects(
                            student: studentProvider.getUser(),
                          ))


);



                      },
                      child: Text('رؤية كل المواد',
                          style: TextStyle(
                              color: TinyColor.fromString("blue").color,
                              fontSize: 12.0,
                              fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Container(
                height: MediaQuery.of(context).size.height/4,
                child: FutureBuilder<List<ClassSubject>>(
                  future: subjectProvider.get2subjects(studentProvider.getUser()),
                  builder: (BuildContext context, AsyncSnapshot<List<ClassSubject>> snapshot) {
                    if (!snapshot.hasData) {
                      return Center(

                        child: CircularProgressIndicator(),
                      );
                    }
                    return 
                  GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10 ,
                  children: snapshot.data.map((subject) => 
                  Container(
                              height: 120,
                              width: 80,
                              decoration: BoxDecoration(
                                  color: Color.fromRGBO(255, 224, 226, 1.0),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              child: Column(
                                children: [
                                  Align(
                                      alignment: Alignment.centerRight,
                                      child: Text(subject.name,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold))),
                                  // Align(
                                  //     alignment: Alignment.centerRight,
                                  //     child: Text(subject.)),
                                  SizedBox(height: 15.0,) ,
                                  Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Image.asset(
                                          'assets/images/diary.png',
                                          width: 50,
                                          height: 60)),
                                ],
                              ),
                            )
                  ).toList(),
                  
                  
                  ); 
                    
                  },
                ),
                
                
                
              )
            ],
          ),
         
        ) ,
        //  bottomNavigationBar: BottomNavyBar(
        //     selectedIndex: _currentIndex,
        //     onItemSelected: (index) {
        //       setState(() => _currentIndex = index);
        //       _pageController.jumpToPage(index);
        //     },
        //     items: <BottomNavyBarItem>[
        //       BottomNavyBarItem(
        //           activeColor: Colors.green,
        //       textAlign: TextAlign.center,
        //           title: Text('الرئيسية'), icon: Icon(Icons.home)),
        //       BottomNavyBarItem(
        //          activeColor: Colors.purpleAccent,
        //       textAlign: TextAlign.center,
        //           title: Text('المواد'), icon: Icon(Icons.subject)),
        //       BottomNavyBarItem(
        //           activeColor: Colors.pink,
        //       textAlign: TextAlign.center,
        //           title: Text('الاخبار'), icon: Icon(Icons.new_releases)),
        //       BottomNavyBarItem(
        //          activeColor: Colors.blue,
        //     textAlign: TextAlign.center ,
        //           title: Text('الاساتذة'), icon: Icon(Icons.person)),
        //     ],
        //   ),
        
        );

    return Consumer<AnimContainer>(
      builder: (context, value, child) => SafeArea(
          child: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            height: double.infinity,
            width: 200,
            decoration: BoxDecoration(color: Colors.blue[100]),
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return ListView(
                  children: [
                    Container(
                      width: constraints.maxWidth,
                      height: constraints.maxHeight / 3,
                      decoration: BoxDecoration(color: Colors.blue[500]),
                      child: Padding(
                        padding: const EdgeInsets.only(right: 30.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                                backgroundImage:
                                    AssetImage('assets/images/user.jpg')),
                            Text(
                              studentProvider.getUser().name,
                              style: GoogleFonts.cairo(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ListTile(
                      title: Text('الملف الشخصي'),
                      onTap: () {
                        Get.to(Material(
                            child: MyPrpfole(studentProvider.getUser())));
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ListTile(
                      title: Text('موقع الجامعة'),
                      onTap: () {
                        Get.to(Material(child: WebSite()));
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ListTile(
                      title: Text('عن التطبيق'),
                      onTap: () {},
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ListTile(
                      title: Text(' تسجيل خروج'),
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                  title: Text(' تسجيل الخروج؟'),
                                  content: Text('هل تريد تسجيل الخروج فعلا؟'),
                                  actions: <Widget>[
                                    FlatButton(
                                      color: Colors.red,
                                      textColor: Colors.white,
                                      child: Text('cancel'),
                                      onPressed: () {
                                        setState(() {
                                          //  codeDialog = valueText;
                                          Navigator.pop(context);
                                        });
                                      },
                                    ),
                                    FlatButton(
                                      color: Colors.green,
                                      textColor: Colors.white,
                                      child: Text('OK'),
                                      onPressed: () async {
                                        await getStorage.write(
                                            'islogged', false);
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (_) =>
                                                    WelcomeScreen()));

                                        // await updateAddress();
                                      },
                                    ),
                                  ],
                                ));
                      },
                    ),
                  ],
                );
              },
            ),
          ),
          AnimatedContainer(
            //matrix
            transform: Matrix4.rotationY(value.rotateY),

            height: double.infinity,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/splash2.jpg'),
                    fit: BoxFit.cover)),

            duration: Duration(milliseconds: 700),
            child: ListView(
              children: [
                Container(
                  height: 80,
                  decoration: BoxDecoration(
                      color: Colors.blue[200],
                      borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(30),
                          bottomLeft: Radius.circular(30))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                          icon: Icon(Icons.sort_outlined),
                          onPressed: () {
                            debugPrint('changed');
                            if (value.rotateY == 0) {
                              value.changeRotation(200.0);
                            } else {
                              value.changeRotation(0.0);
                            }
                          }),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('StudentApp',
                            style: GoogleFonts.firaMono(
                                fontWeight: FontWeight.bold, fontSize: 20)),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
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
                                image: DecorationImage(image: AssetImage(i))),
                          );
                        },
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: MediaQuery.of(context).size.height / 2,
                  decoration: BoxDecoration(
                      color: Colors.white70,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(50),
                        topRight: Radius.circular(50),
                      )),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            FlatButton.icon(
                                onPressed: () {
                                  Get.to(MyCourses(studentProvider.getUser()));
                                },
                                icon: Icon(
                                  Icons.laptop,
                                  size: 60,
                                ),
                                label: Text('الكورسات')),
                            FlatButton.icon(
                                onPressed: () {
                                  Get.to(Material(child: Events()));
                                },
                                icon: Icon(
                                  FontAwesomeIcons.newspaper,
                                  size: 60,
                                ),
                                label: Text('الأخبار'))
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            FlatButton.icon(
                                onPressed: () {
                                  Get.to(Teachers());
                                },
                                icon: Icon(
                                  FontAwesomeIcons.user,
                                  size: 60,
                                ),
                                label: Text('الأساتذة')),
                            FlatButton.icon(
                                onPressed: () {
                                  Get.to(Consults());
                                },
                                icon: Icon(
                                  FontAwesomeIcons.question,
                                  size: 60,
                                ),
                                label: Text('الإستفسارات'))
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      )),
    );
  }

  Widget lecureDetails(lecur) {
    var subject = lecur['name'];
    return Stack(
      children: [
        Positioned(top: 8, child: Text(lecur['dept'].toString())),
        Center(child: Text(subject.toString()))
      ],
    );
  }
}







/*
topics:
dept
level
idNumber
general

IT= IT


*/
