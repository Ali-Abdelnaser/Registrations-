import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'attendes_state.dart';

class AttendesCubit extends Cubit<AttendesState> {
  AttendesCubit() : super(AttendesInitial());
}
