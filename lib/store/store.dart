import 'package:flutter/foundation.dart';

import 'appstate.dart';
import 'action.dart';

class Store with ChangeNotifier {
  AppState state = AppState();
  List<Action> actions = []; //actions currently being taken
  
  void loadState(){
    
  }

  void saveState(){

  }

  bool isLoading(){
    return actions.where((a) => a.type == ActionType.STATE_LOAD && a.state == ActionState.RUNNING).isNotEmpty;
  }

}