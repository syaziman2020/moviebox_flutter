import 'package:equatable/equatable.dart';

class AddFavoriteResponse extends Equatable {
  final bool success;
  final String message;

  const AddFavoriteResponse({required this.success, required this.message});
  @override
  List<Object?> get props => [success, message];
}
