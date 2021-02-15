import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:student_side/ui/views/registeration/regiteration_screen.dart';
import 'package:student_side/util/firebase_init.dart';

class RegisterationSteps extends StatefulWidget {
  RegisterationSteps({Key key}) : super(key: key);

  @override
  _RegisterationStepsState createState() => _RegisterationStepsState();
}

class _RegisterationStepsState extends State<RegisterationSteps> {


@override
void initState() { 
  super.initState();
  FirebaseInit.initFirebase();

  query();
}
query() async{
  FirebaseFirestore.instance
  .collection('student')
  .where('id_number', isEqualTo: '2012302389' )
  .where('email', isEqualTo: 'abdo@gmail.com')
  .get()
  .then((QuerySnapshot snapshot){
 print(snapshot.docs == null);
 
  snapshot.docs.forEach((doc) {
    print(';dkjfdjfkldjf;adskfjad;ksjf;dkjsfa;djfa;dskjf;adkjf;dasjf;kadj');
            print(doc["id_number"]);

setState(() {
  this.id =  doc["id_number"]!= null?doc["id_number"]: 'no Id';
});

            print(doc== null);
        });
  });
}


List<Step> steps = [
    Step(
      title: const Text('step one'),
      isActive: true,
      state: StepState.complete,
      content:  RegisterationView()
    ),
    Step(
      isActive: false,
      state: StepState.editing,
      title: const Text('add image'),
      content: Column(
        children: <Widget>[
          TextFormField(
            decoration: InputDecoration(labelText: 'Home Address'),
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'Postcode'),
          ),
        ],
      ),
    ),];

int currentStep = 0;
bool complete = false;

next() {
  currentStep + 1 != steps.length
      ? goTo(currentStep + 1)
      : setState(() => complete = true);
}

cancel() {
  if (currentStep > 0) {
    goTo(currentStep - 1);
  }
}

goTo(int step) {
  setState(() => currentStep = step);
}
String id='';
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text('Student'+this.id),
      ),
      body: Column(children: <Widget>[
        Expanded(
          child: Stepper(
          steps: steps,
          currentStep: currentStep,
          onStepContinue: next,
          onStepTapped: (step) => goTo(step),
          onStepCancel: cancel,
          ),
        ),
      ]));
  }
}