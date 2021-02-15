class Department{
  int id;
  String name;

Department(this.id, this.name);



Department.fromJson(Map<dynamic, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }



}