import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

abstract class InternetState {}

class InternetInitial extends InternetState {}

class InternetConnected extends InternetState {}

class InternetDisconnected extends InternetState {}

class InternetCubit extends Cubit<InternetState> {
  final Connectivity _connectivity = Connectivity();

  InternetCubit() : super(InternetInitial()) {
    // نسمع للتغييرات
    _connectivity.onConnectivityChanged.listen((
      List<ConnectivityResult> results,
    ) {
      if (results.contains(ConnectivityResult.mobile) ||
          results.contains(ConnectivityResult.wifi)) {
        emit(InternetConnected());
      } else {
        emit(InternetDisconnected());
      }
    });
  }

  Future<void> checkConnection() async {
    final connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult.contains(ConnectivityResult.mobile) ||
        connectivityResult.contains(ConnectivityResult.wifi)) {
      emit(InternetConnected());
    } else {
      emit(InternetDisconnected());
    }
  }
}
