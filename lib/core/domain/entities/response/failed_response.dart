import 'package:equatable/equatable.dart';

class FailedResponse extends Equatable {
  final String errorMessage;

  const FailedResponse({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}
