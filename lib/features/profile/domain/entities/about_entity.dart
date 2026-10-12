import 'package:equatable/equatable.dart';

class AboutEntity extends Equatable {
  const AboutEntity({required this.about});

  final String about;

  @override
  List<Object?> get props => [about];
}
