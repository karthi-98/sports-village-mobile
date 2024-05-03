import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sports_village/Bloc/bloc_events.dart';
import 'package:sports_village/Bloc/bloc_states.dart';

class GlobalBloc extends Bloc<GlobalEvents, GlobalStates> {
  GlobalBloc(): super(const GlobalStates()){
    on<PickedTimeSlotsEvents>(_pickedTimeSlotsEvents);
  }

  void _pickedTimeSlotsEvents(PickedTimeSlotsEvents event, Emitter<GlobalStates> emit) {
    emit(state.copyWith(pickedTimeSlots: event.pickedTimeSlots));
  }
}

class ArenaChange {
  final int arenaValue;
  ArenaChange({required this.arenaValue});
}
class ArenaBloc extends Bloc<ArenaChange,int> {
  ArenaBloc() : super(0) {
    on<ArenaChange>((event,emit) {
      emit(event.arenaValue);
    });
  }
}

class DatePickedChangeDate {
  final String date;
  DatePickedChangeDate({required this.date});
}
class DatePickedBloc extends Bloc<DatePickedChangeDate, String> {
  DatePickedBloc() : super("Date not yet picked") {
    on<DatePickedChangeDate>((event,emit) {
      emit(event.date);
    });
  }
}
