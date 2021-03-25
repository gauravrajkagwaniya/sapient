class Local {
  List<String> todo;

  Local({this.todo});

  Local.fromJson(Map<String, dynamic> json) {
    todo = json['todo'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['todo'] = this.todo;
    return data;
  }
}