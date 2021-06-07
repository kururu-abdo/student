class Semester{

  int id;
  String name;

  Semester(this.id , this.name);

  Semester.fromJson(Map<dynamic ,dynamic> data){
    this.id =  data['id'];
    this.name = data['name'];
  }


  Map<dynamic ,dynamic>   toJson(){
    return {
'id': this.id ,
'name':this.name

    };
  }
}