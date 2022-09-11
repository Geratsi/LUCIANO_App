part of 'profile_change_bloc.dart';

abstract class ProfileChangeEvent extends Equatable {
  const ProfileChangeEvent();

  @override
  List<Object?> get props => [];
}

class ProfileChangeUpdateEvent extends ProfileChangeEvent {}
