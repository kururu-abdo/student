class Rating{
  String id;
  String body;
  int time;
   

   Rating.fromJson(Map <dynamic , dynamic >  data) {
     this.id = data['id'];
    this.body =  data['body'];
    this.time = data['time'];



   }

Map <dynamic , dynamic >  toJson ()=>{"id":  this.id  ,"body":  this.body ,"time" :this.time};
}