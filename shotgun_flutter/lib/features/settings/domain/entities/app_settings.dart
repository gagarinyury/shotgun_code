import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:shotgun_flutter/features/llm_executor/domain/entities/llm_provider_type.dart';

class AppSettings extends Equatable {
  final ThemeMode themeMode;
  final LLMProviderType defaultLLMProvider;
  final double fontSize;
  final bool autoSave;

  const AppSettings({
    this.themeMode = ThemeMode.system,
    this.defaultLLMProvider = LLMProviderType.gemini,
    this.fontSize = 14.0,
    this.autoSave = true,
  });

  AppSettings copyWith({
    ThemeMode? themeMode,
    LLMProviderType? defaultLLMProvider,
    double? fontSize,
    bool? autoSave,
  }) {
    return AppSettings(
      themeMode: themeMode ?? this.themeMode,
      defaultLLMProvider: defaultLLMProvider ?? this.defaultLLMProvider,
      fontSize: fontSize ?? this.fontSize,
      autoSave: autoSave ?? this.autoSave,
    );
  }

  @override
  List<Object?> get props => [
    themeMode,
    defaultLLMProvider,
    fontSize,
    autoSave,
  ];
}
