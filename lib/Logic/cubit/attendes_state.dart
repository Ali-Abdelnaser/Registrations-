import 'package:equatable/equatable.dart';
import 'package:registration/data/models/attendee.dart';

abstract class BranchMembersState extends Equatable {
  @override
  List<Object?> get props => [];
}

class BranchMembersInitial extends BranchMembersState {}

class BranchMembersLoading extends BranchMembersState {}

class BranchMembersLoaded extends BranchMembersState {
  final List<Attendee> members;
  BranchMembersLoaded(this.members);

  @override
  List<Object?> get props => [members];
}

class BranchMembersError extends BranchMembersState {
  final String message;
  BranchMembersError(this.message);

  @override
  List<Object?> get props => [message];
}

class BranchMemberUpdated extends BranchMembersState {}

class BranchMemberDeleted extends BranchMembersState {}
