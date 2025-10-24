import 'package:flutter/material.dart';

/// A widget that displays the estimated token count with color coding.
///
/// The color changes based on token count:
/// - Green: < 50,000 tokens (safe)
/// - Orange: 50,000 - 100,000 tokens (warning)
/// - Red: > 100,000 tokens (danger)
class TokenCounter extends StatelessWidget {
  /// The estimated number of tokens
  final int tokens;

  /// Optional callback when the counter is tapped
  final VoidCallback? onTap;

  const TokenCounter({
    super.key,
    required this.tokens,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = _getColorForTokens(tokens);
    final textColor = _getTextColorForBackground(color);

    return GestureDetector(
      onTap: onTap,
      child: Chip(
        label: Text(
          '~${_formatNumber(tokens)} tokens',
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      ),
    );
  }

  /// Returns the appropriate background color based on token count.
  Color _getColorForTokens(int tokens) {
    if (tokens < 50000) {
      return Colors.green[100]!;
    } else if (tokens < 100000) {
      return Colors.orange[100]!;
    } else {
      return Colors.red[100]!;
    }
  }

  /// Returns appropriate text color for the given background color.
  Color _getTextColorForBackground(Color backgroundColor) {
    // Use dark text for light backgrounds
    return Colors.black87;
  }

  /// Formats large numbers with commas for readability.
  String _formatNumber(int number) {
    if (number < 1000) return number.toString();

    final formatter = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    return number.toString().replaceAllMapped(
          formatter,
          (match) => '${match[1]},',
        );
  }
}
