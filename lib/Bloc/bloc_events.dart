abstract class GlobalEvents {
  const GlobalEvents();
}

class PickedTimeSlotsEvents extends GlobalEvents{
  final List<int> pickedTimeSlots;
  PickedTimeSlotsEvents(this.pickedTimeSlots);
}