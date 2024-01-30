import 'package:flutter/material.dart';

enum CapteurSlotState { recherche, trouve, connecte }

class CapteurStateNotifier extends ChangeNotifier {
  CapteurSlotState _slot1State = CapteurSlotState.recherche;
  CapteurSlotState _slot2State = CapteurSlotState.recherche;

  CapteurSlotState get slot1State => _slot1State;
  CapteurSlotState get slot2State => _slot2State;

  void setSlot1State(CapteurSlotState state) {
    _slot1State = state;
    notifyListeners();
  }

  void setSlot2State(CapteurSlotState state) {
    _slot2State = state;
    notifyListeners();
  }
}
