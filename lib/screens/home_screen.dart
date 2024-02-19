import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:google_sign_in/google_sign_in.dart";
import "package:messaging/api/apis.dart";
import "package:messaging/main.dart";
import "package:messaging/models/chat_user.dart";
import "package:messaging/screens/profile_screen%20.dart";
import "package:messaging/widgets/chat_user_card.dart";

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<ChatUser> _list = [];
  final List<ChatUser> _searchList = [];
  bool _isSearching = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      // ignore: deprecated_member_use
      child: WillPopScope(
        onWillPop: (){
          if(_isSearching){
            setState(() {
              _isSearching =! _isSearching;
            });
            return Future.value(false);
          }else{
            return Future.value(true);
          }
        },
        child: Scaffold(
          appBar: AppBar(
            leading: Icon(CupertinoIcons.home),
          title: _isSearching ? TextField(
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'Name, Email..'
            ),
            autofocus: true,
            style: TextStyle(fontSize: 17, letterSpacing: 0.5),
            onChanged: (val){
              _searchList.clear();
              for(var i in _list){
                if(i.name.toLowerCase().contains(val.toLowerCase()) || i.email.toLowerCase().contains(val.toLowerCase())){
                  _searchList.add(i);
                }
                setState(() {
                  _searchList;
                });
              }
            },
          ) : Text('Messaging'),
          actions: [
            IconButton(onPressed: (){
              setState(() {
                _isSearching = ! _isSearching;
              });
            }, icon: Icon(_isSearching ? CupertinoIcons.clear_circled_solid : Icons.search)),
            IconButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (_)=>ProfileScreen(user: APIs.me)));
            }, icon: const Icon(Icons.more_vert))
          ],
          ),
        
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom:10),
            child: FloatingActionButton(
              onPressed: ()async{
                await APIs.auth.signOut();
                await GoogleSignIn().signOut();
              },
              child: const Icon(Icons.add_comment_rounded)),
          ),
        
          body: StreamBuilder(
            stream: APIs.getAllUsers(),
            builder:(context, snapshot){
              
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                case ConnectionState.none:
                  return Center(child: CircularProgressIndicator());
                
                case ConnectionState.active:
                case ConnectionState.done:
                final data = snapshot.data?.docs;
                _list = data?.map((e) => ChatUser.fromJson(e.data())).toList()??[];
              
              if(_list.isNotEmpty){
                return ListView.builder(
                itemCount:_isSearching ? _searchList.length : _list.length,
                padding: EdgeInsets.only(top: mq.height *.01),
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index){
                return ChatUserCard(user:_isSearching ? _searchList[index] : _list[index]);
                //return Text('Name: ${list[index]}');
              });
              }else{
                return Center(child: Text('No Connections Found',style: TextStyle(fontSize: 20),));
              }
              }
            },
          ),
        ),
      ),
    );
  }
  @override
  void initState() {
    super.initState();
    APIs.getSelfInfo();
  }
}