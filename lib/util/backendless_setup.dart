import 'package:backendless_sdk/backendless_sdk.dart';
import 'package:student_side/util/constants.dart';

class BackendlessServer{


  static const String SERVER_URL = "https://api.backendless.com";
  static const String APPLICATION_ID = "CAF922FA-A463-30A9-FFC0-A41E5B046000";
  static const String ANDROID_API_KEY = "3A8553F0-AEE3-49C7-86CD-4CABCD553633";
  static const String IOS_API_KEY = "9197C45D-98A8-4342-9BC7-B603D9E97F19";
	static const String JS_API_KEY = "FA7E577C-F7D2-4C24-8C4E-72F11923F4EE";

	BackendlessServer(){
init();

  }
	void init() async{
 await Backendless.setUrl(SERVER_URL);
    await Backendless.initApp(
      APPLICATION_ID,
      ANDROID_API_KEY,
      IOS_API_KEY);
		await Backendless.initWebApp(
			APPLICATION_ID,
			JS_API_KEY);

  }


  
  void sendData() async{
  }


  static registerChannel()  async{
	  Backendless.messaging.registerDevice([getStorage.read(USER_ID).toString()]  ,null ,onMessage).then(
   (response) => print("Device has been registered!"));
  }

  static registerChatChcannel() async{
	  Channel channel = await Backendless.messaging.subscribe(getStorage.read(USER_ID).toString());
channel.addMessageListener((String message) {
  print("Received a message: $message");
});
  }

static void onMessage(Map<String, dynamic> args) {
   args.forEach((k, v) => print("$k: $v"));
}



}