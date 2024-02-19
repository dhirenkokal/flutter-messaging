import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:messaging/api/apis.dart';
import 'package:messaging/main.dart';
import 'package:messaging/models/chat_user.dart';
import 'package:messaging/models/message.dart';
import 'package:messaging/widgets/message_card.dart';

class ChatScreen extends StatefulWidget {
  final ChatUser user;
  const ChatScreen({super.key, required this.user});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

List<Message> _list = [];

final _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          flexibleSpace: _appBar(),
        ),
        backgroundColor: Colors.white,

        body: Column(
          children: [
            
            Expanded(
              child: StreamBuilder(
              stream: APIs.getAllMessages(widget.user),
              builder:(context, snapshot){
                
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                    return SizedBox();
                  
                  case ConnectionState.active:
                  case ConnectionState.done:
                  final data = snapshot.data?.docs;
                  _list = data?.map((e) => Message.fromJson(e.data())).toList()??[];
                
                
                if(_list.isNotEmpty){
                  return ListView.builder(
                  itemCount: _list.length,
                  padding: EdgeInsets.only(top: mq.height *.01),
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index){
                  return MessageCard(message: _list[index]);
                });
                }else{
                  return Center(child: Text('Say Hi👋',style: TextStyle(fontSize: 20),));
                }
                }
              },
            ),
          ),
         _chatInput(),]),
      ),
    );
  }
  Widget _appBar(){
    return InkWell(
      onTap: (){},
      child: Row(children: [
        IconButton(onPressed: () => Navigator.pop(context), icon: Icon(Icons.arrow_back, color: Colors.black54,)),
      
        ClipRRect(
              borderRadius: BorderRadius.circular(mq.height *.3),
              child: CachedNetworkImage(
                width: mq.height *.045,
                height: mq.height *.045,
                imageUrl: widget.user.image,
                //placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => CircleAvatar(child: Icon(CupertinoIcons.person)),
                ),
            ),
      
            SizedBox(width: 10,),
      
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.user.name,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors. black87,
                  fontWeight: FontWeight.w500 )),
      
                  SizedBox(height: 1,),
      
                  Text('Last Seen Not Available',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors. black54 )),
                  
                  
                  ],)
      ],),
    );
  }

  Widget _chatInput(){
    return Padding(
      padding: EdgeInsets.symmetric(vertical: mq.height*.01,horizontal: mq.width*.025),
      child: Row(
        children: [
          Expanded(
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: Row(children: [
                IconButton(onPressed: (){}, icon: Icon(Icons.emoji_emotions, color: Colors.blueAccent,size: 25,)),
                Expanded(child: TextField(
                  controller: _textController,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: InputDecoration(hintText: 'Type Something..',hintStyle: TextStyle(color: Colors.blue),border: InputBorder.none),
                )),
                SizedBox(width: mq.width*.02,)
              ],),
            ),
          ),
          MaterialButton(onPressed: (){
            if(_textController.text.isNotEmpty){
              APIs.sendMessage(widget.user, _textController.text);
              _textController.text = '';
            }
          },minWidth: 1,padding: EdgeInsets.only(top: 10,right: 5,left: 10,bottom: 10),shape: CircleBorder(), color: Colors.green, child: Icon(Icons.send,color: Colors.white,size: 28,),)
        ],
      ),
    );
  }
}