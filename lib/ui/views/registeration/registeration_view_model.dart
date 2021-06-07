import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:load/load.dart';
import 'package:stacked/stacked.dart';
import 'package:student_side/model/department.dart';
import 'package:student_side/model/level.dart';
import 'package:form_bloc/form_bloc.dart';

class RegisterationViewModel extends BaseViewModel {
  String _title = 'Home View';
  String get title => _title;

  var first_name = Rx<String>();
  var last_name = Rx<String>();
  var id_number = Rx<String>();
  var email = Rx<String>();
  var password = Rx<String>();
  var dept = Rx<Department>();
  var level = Rx<Level>();

  Future<bool> addStudent() async {}
}

class RegistertionFormBloc extends FormBloc<String, String> {
  List<Level> levels = [];
  final emailField = TextFieldBloc(
      validators: [FieldBlocValidators.email, FieldBlocValidators.required]);
  final passwordField =
      TextFieldBloc(validators: [FieldBlocValidators.required]);
  final idNumberField =
      TextFieldBloc(validators: [FieldBlocValidators.required]);
  final firstNameField =
      TextFieldBloc(validators: [FieldBlocValidators.required]);
  final lastNameField =
      TextFieldBloc(validators: [FieldBlocValidators.required]);

  final nameField = TextFieldBloc(validators: [FieldBlocValidators.required]);

  RegistertionFormBloc() {
    addFieldBlocs(
      step: 0,
      fieldBlocs: [emailField, passwordField, idNumberField, nameField],
    );
    addFieldBlocs(
      step: 1,
      // fieldBlocs: [firstName, lastName, gender, birthDate],
    );
  }
  @override
  List<FieldBloc> get fieldBlocs =>
      [emailField, passwordField, idNumberField, firstNameField, lastNameField];

  @override
  Stream<FormBlocState<String, String>> onSubmitting() async* {
    try {} catch (e) {
      yield state.toFailure();
    }
  }

  Future<List<Level>> fetch_levels() async {
    var future = await showLoadingDialog();

    FirebaseFirestore firestore = FirebaseFirestore.instance;

    var level = firestore.collection('level');

    var fetchedLevel = await level.get();

    Iterable I = fetchedLevel.docs;

    levels = I.map((e) => Level.fromJson(e.data())).toList();

    for (var item in fetchedLevel.docs) {
      print(item.data());
    }

    future.dismiss();

    return levels;
  }
}
