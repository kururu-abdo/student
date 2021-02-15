import 'dart:io';

Future<bool> isConnectec()  async{

  try {
    var result = await  InternetAddress.lookup('www.google.com');

    if (result.isNotEmpty  && result[0].rawAddress.isNotEmpty){
return true;
    }else{
      return false;
    }
  } catch (e) {
    return false;
  }
}