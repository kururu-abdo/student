class Day{
  int id;
  String name;
  Day(this.id,  this.name);
  Day.fromJson(Map<dynamic ,dynamic> data){
    this.id = data['id'];
    this.name= data['name'];

  }

Map<dynamic ,dynamic>  toJson()=>{'id':this.id , 'name':this.name};

}