import 'dart:async';
import 'db_helper.dart';
import 'user.dart';


//getUsers() will get the data from the database asynchronously. 
// whenever getUsers() is called after update or delete the data will get the data right away.

class UserBloc {

   final _userController = StreamController<List<User>>();

   get userStream => _userController.stream;

   getUsers() async => _userController.sink.add(await DbHelper.dbInstance.getUsers());
    
   UserBloc() {getUsers();}

   deleteUser(int id)
   {
      DbHelper.dbInstance.deleteUser(id);
      getUsers();
   }
   
   addUser(User user)
   {
     DbHelper.dbInstance.addUser(user);
     getUsers();
   }
   
   updateUser(User user)
   {
      DbHelper.dbInstance.updateUser(user);
      getUsers();
   }
    
 

  dispose() => _userController.close();
 

}
