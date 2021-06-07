import 'package:form_bloc/form_bloc.dart';
import 'package:get/get.dart';

class LoginViewModel extends  GetxController{
var idNumber =  ''.obs;
var password = ''.obs;










}


class LoginFormBloc extends  FormBloc<String, String>{
   final idNumberField = TextFieldBloc();
     final passwordField = TextFieldBloc();
LoginFormBloc(){
  addFieldBlocs(fieldBlocs: fieldBlocs);
}
  @override
  // TODO: implement fieldBlocs
  List<FieldBloc> get fieldBlocs =>[idNumberField ,passwordField];

  @override
  Stream<FormBlocState<String, String>> onSubmitting()  async*{
try {
  
} catch (e) {
}


  }


  
}