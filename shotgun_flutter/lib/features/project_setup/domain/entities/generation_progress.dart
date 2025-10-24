import 'package:equatable/equatable.dart';

/// Represents progress during context generation.
///
/// Used to track how many files have been processed out of the total.
/// The UI can use this to show a progress bar or percentage.
class GenerationProgress extends Equatable {
  /// Number of files processed so far.
  final int current;

  /// Total number of files to process.
  final int total;

  const GenerationProgress({
    required this.current,
    required this.total,
  });

  /// Calculate percentage (0.0 to 1.0).
  ///
  /// Returns 0.0 if total is 0 to avoid division by zero.
  double get percentage => total > 0 ? current / total : 0.0;

  @override
  List<Object?> get props => [current, total];
}
