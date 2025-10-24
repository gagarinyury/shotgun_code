import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String email;
  final String? displayName;
  final String? photoUrl;
  final DateTime createdAt;

  const User({
    required this.id,
    required this.email,
    this.displayName,
    this.photoUrl,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, email, displayName, photoUrl, createdAt];
}

class AuthState extends Equatable {
  final User? user;
  final bool isLoading;
  final String? error;

  const AuthState({this.user, this.isLoading = false, this.error});

  const AuthState.initial() : user = null, isLoading = false, error = null;

  const AuthState.loading() : user = null, isLoading = true, error = null;

  const AuthState.authenticated(this.user) : isLoading = false, error = null;

  const AuthState.error(this.error) : user = null, isLoading = false;

  @override
  List<Object?> get props => [user, isLoading, error];
}
