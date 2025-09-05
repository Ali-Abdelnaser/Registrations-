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

class ImportProgress extends BranchMembersState {
  final double progress;
  final int current;
  final int total;

  ImportProgress({
    required this.progress,
    required this.current,
    required this.total,
  });
}
class BranchMembersImportedReport extends BranchMembersState {
  final int inserted;
  final int updated;
  final int skipped;
  final int failed;
  final int total;

  BranchMembersImportedReport({
    required this.inserted,
    required this.updated,
    required this.skipped,
    required this.failed,
    required this.total,
  });
}
