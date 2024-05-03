class GlobalStates {
  const GlobalStates({this.pickedTimeSlots = const <int>[]});

  final List<int> pickedTimeSlots;

  GlobalStates copyWith({List<int>? pickedTimeSlots}) {
    return GlobalStates(pickedTimeSlots: pickedTimeSlots??this.pickedTimeSlots);
  } 

}