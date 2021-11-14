/**
 * Action represents an action being taken by the store
 * includes time action started, current action state, action type
 */
class Action {
  int? started; //epoch time, when action started executing
  ActionState? state;
  ActionType? type;
}

enum ActionState { RUNNING, OK, ERROR }

enum ActionType {
  //all possible actions that the app could take are defined here
  STATE_LOAD,
  STATE_SAVE,
  POST_SUBMIT,
  POST_GET,
  POST_VOTE, //for example
  SETTINGS_SET_LIMIT,
  SETTINGS_SET_ORDER,
  SETTINGS_SET_MODE,
}
