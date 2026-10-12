import 'package:equatable/equatable.dart';

import '../../domain/entities/about_entity.dart';
import '../../domain/entities/term_condition_entity.dart';
import '../../domain/entities/rule_entity.dart';
import 'profile_content_event.dart';

sealed class ProfileContentState extends Equatable {
  const ProfileContentState();

  @override
  List<Object?> get props => [];
}

final class ProfileContentInitial extends ProfileContentState {
  const ProfileContentInitial();
}

final class ProfileContentLoading extends ProfileContentState {
  const ProfileContentLoading(this.type);

  final ProfileContentType type;

  @override
  List<Object?> get props => [type];
}

final class ProfileContentLoaded extends ProfileContentState {
  const ProfileContentLoaded({
    required this.type,
    this.about = const [],
    this.termConditions = const [],
    this.rules = const [],
    this.isRefreshing = false,
  });

  final ProfileContentType type;
  final List<AboutEntity> about;
  final List<TermConditionEntity> termConditions;
  final List<RuleEntity> rules;
  final bool isRefreshing;

  bool get isEmpty {
    return switch (type) {
      ProfileContentType.about => about.isEmpty,
      ProfileContentType.termConditions => termConditions.isEmpty,
      ProfileContentType.rules => rules.isEmpty,
    };
  }

  ProfileContentLoaded copyWith({bool? isRefreshing}) {
    return ProfileContentLoaded(
      type: type,
      about: about,
      termConditions: termConditions,
      rules: rules,
      isRefreshing: isRefreshing ?? this.isRefreshing,
    );
  }

  @override
  List<Object?> get props => [type, about, termConditions, rules, isRefreshing];
}

final class ProfileContentError extends ProfileContentState {
  const ProfileContentError({required this.type, required this.message});

  final ProfileContentType type;
  final String message;

  @override
  List<Object?> get props => [type, message];
}
