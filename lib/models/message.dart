class Message {
  Message({
    required this.formid,
    required this.msg,
    required this.read,
    required this.told,
    required this.type,
    required this.sent,
  });
  late final String formid;
  late final String msg;
  late final String read;
  late final String told;
  late final Type type;
  late final String sent;
  
  Message.fromJson(Map<String, dynamic> json){
    formid = json['formid'].toString();
    msg = json['msg'].toString();
    read = json['read'].toString();
    told = json['told'].toString();
    type = json['type'].toString() == Type.image.name?Type.image:Type.text;
    sent = json['sent'].toString();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['formid'] = formid;
    data['msg'] = msg;
    data['read'] = read;
    data['told'] = told;
    data['type'] = type.name;
    data['sent'] = sent;
    return data;
  }
}
enum Type{text,image}