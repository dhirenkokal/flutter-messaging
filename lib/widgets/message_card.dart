import 'package:flutter/material.dart';
import 'package:messaging/api/apis.dart';
import 'package:messaging/helper/my_date_util.dart';
import 'package:messaging/main.dart';
import 'package:messaging/models/message.dart';

class MessageCard extends StatefulWidget {
  final Message message;

  const MessageCard({super.key, required this.message});

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  @override
  Widget build(BuildContext context) {
    return APIs.user.uid == widget.message.formid ? _greenMessage() : _blueMessage();
  }

  Widget _blueMessage(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Container(
            padding: EdgeInsets.all(mq.width *.04),
            margin: EdgeInsets.symmetric(horizontal: mq.width *.04, vertical: mq.height *.01),
            decoration: BoxDecoration(
              color: Colors.blue.shade100,
              border: Border.all(color: Colors.lightBlue),
              borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30),bottomRight: Radius.circular(30))),
            child: Text(widget.message.msg, style: TextStyle(fontSize: 15, color: Colors.black87),),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(right: mq.width *.04),
          child: Text(MyDateUtil.getFormattedTime(context: context, time: widget.message.sent), style: TextStyle(fontSize: 13, color: Colors.black54),),
        )
      ],
    );
  }

  Widget _greenMessage(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            SizedBox(width: mq.width *.04),
            if(widget.message.read.isNotEmpty)
            Icon(Icons.done_all_rounded, color: Colors.blue,size: 20,),
            SizedBox(width: 2,),
            Text(MyDateUtil.getFormattedTime(context: context, time: widget.message.sent), style: TextStyle(fontSize: 13, color: Colors.black54),),
          ],
        ),

        Flexible(
          child: Container(
            padding: EdgeInsets.all(mq.width *.04),
            margin: EdgeInsets.symmetric(horizontal: mq.width *.04, vertical: mq.height *.01),
            decoration: BoxDecoration(
              color: Colors.green.shade100,
              border: Border.all(color: Colors.lightGreen),
              borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30),bottomLeft: Radius.circular(30))),
            child: Text(widget.message.msg, style: TextStyle(fontSize: 15, color: Colors.black87),),
          ),
        ),
        
      ],
    );
  }

}
