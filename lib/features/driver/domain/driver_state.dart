import 'package:equatable/equatable.dart';
import 'package:ridesharingapp/features/ride_request/data/ride_model.dart';

class DriverState {
  const DriverState();
}

class DriverStateDriver extends DriverState with EquatableMixin {
  final bool isLoading;
  final bool isOnline;
  final Exception? error;
  final List<RideModel>? rides;

  DriverStateDriver({
    required this.isLoading,
    required this.error,
    required this.isOnline,
    required this.rides,
  });

  DriverStateDriver copyWith({
    bool? isLoading,
    Exception? error,
    bool? isOnline,
    List<RideModel>? rides,
  }) {
    return DriverStateDriver(
      isLoading: isLoading ?? this.isLoading,
      isOnline: isOnline ?? this.isOnline,
      error: error,
      rides: rides ?? this.rides,
    );
  }

  @override
  List<Object?> get props => [isLoading, error, rides];
}

class DriverStateInitial extends DriverState {
  const DriverStateInitial();
}
