import 'dart:ffi' as ffi;
import 'dart:io';
import 'package:ffi/ffi.dart';

/// C function typedef for ListFilesFFI
typedef ListFilesFFIC = ffi.Pointer<Utf8> Function(ffi.Pointer<Utf8>);

/// Dart function typedef for ListFilesFFI
typedef ListFilesFFIDart = ffi.Pointer<Utf8> Function(ffi.Pointer<Utf8>);

/// C function typedef for FreeString
typedef FreeStringC = ffi.Void Function(ffi.Pointer<Utf8>);

/// Dart function typedef for FreeString
typedef FreeStringDart = void Function(ffi.Pointer<Utf8>);

/// C function typedef for SplitDiffFFI
typedef SplitDiffFFIC = ffi.Pointer<Utf8> Function(
  ffi.Pointer<Utf8>,
  ffi.Int,
);

/// Dart function typedef for SplitDiffFFI
typedef SplitDiffFFIDart = ffi.Pointer<Utf8> Function(
  ffi.Pointer<Utf8>,
  int,
);

/// Bridge to communicate with Go backend via FFI.
///
/// This class handles:
/// - Loading platform-specific shared libraries (.dylib, .so, .dll)
/// - Calling Go functions exported via CGo
/// - Memory management (freeing C strings)
///
/// The Go backend must be compiled as a C-shared library with exported functions:
/// - `ListFilesFFI`: Lists files in a directory
/// - `FreeString`: Frees C string memory
///
/// Example usage:
/// ```dart
/// final bridge = BackendBridge();
/// final jsonResult = bridge.listFiles('/path/to/dir');
/// // Parse JSON result
/// bridge.dispose();
/// ```
class BackendBridge {
  late ffi.DynamicLibrary _lib;
  late ListFilesFFIDart _listFiles;
  late SplitDiffFFIDart _splitDiff;
  late FreeStringDart _freeString;

  /// Creates a new BackendBridge instance.
  ///
  /// Automatically loads the correct shared library based on the current platform.
  /// Throws [UnsupportedError] if the platform is not supported.
  BackendBridge() {
    _lib = _loadLibrary();
    _listFiles = _lib.lookupFunction<ListFilesFFIC, ListFilesFFIDart>(
      'ListFilesFFI',
    );
    _splitDiff = _lib.lookupFunction<SplitDiffFFIC, SplitDiffFFIDart>(
      'SplitDiffFFI',
    );
    _freeString = _lib.lookupFunction<FreeStringC, FreeStringDart>(
      'FreeString',
    );
  }

  /// Loads the platform-specific shared library.
  ///
  /// Supports:
  /// - macOS: libshotgun_arm64.dylib (Apple Silicon) or libshotgun_amd64.dylib (Intel)
  /// - Linux: libshotgun.so
  /// - Windows: shotgun.dll
  ///
  /// Throws [UnsupportedError] if platform is not supported.
  ffi.DynamicLibrary _loadLibrary() {
    if (Platform.isLinux) {
      return ffi.DynamicLibrary.open('linux/libshotgun.so');
    } else if (Platform.isMacOS) {
      // Detect architecture
      final arch = ffi.Abi.current().toString();
      if (arch.contains('arm64') || arch.contains('Arm64')) {
        return ffi.DynamicLibrary.open('macos/libshotgun_arm64.dylib');
      } else {
        return ffi.DynamicLibrary.open('macos/libshotgun_amd64.dylib');
      }
    } else if (Platform.isWindows) {
      return ffi.DynamicLibrary.open('windows/shotgun.dll');
    }
    throw UnsupportedError(
      'Platform ${Platform.operatingSystem} is not supported',
    );
  }

  /// Lists all files and directories in the given path.
  ///
  /// Calls the Go backend's `ListFilesFFI` function via FFI.
  ///
  /// Parameters:
  /// - [path]: Absolute path to the directory to list
  ///
  /// Returns:
  /// - JSON string with file tree structure or error object
  ///
  /// The returned JSON has two possible formats:
  /// 1. Success: `[{...file node...}, ...]`
  /// 2. Error: `{"error": "error message"}`
  ///
  /// Memory is automatically freed after the call.
  String listFiles(String path) {
    // Convert Dart string to C string
    final pathPtr = path.toNativeUtf8();

    // Call Go function
    final resultPtr = _listFiles(pathPtr);

    // Convert C string to Dart string
    final result = resultPtr.toDartString();

    // Free memory
    malloc.free(pathPtr);
    _freeString(resultPtr);

    return result;
  }

  /// Splits a large diff into smaller patches.
  ///
  /// Calls the Go backend's `SplitDiffFFI` function via FFI.
  ///
  /// Parameters:
  /// - [diff]: The raw Git diff content
  /// - [lineLimit]: Maximum number of lines per patch
  ///
  /// Returns:
  /// - JSON string with array of split patches or error object
  ///
  /// The returned JSON has two possible formats:
  /// 1. Success: `["patch1...", "patch2...", ...]`
  /// 2. Error: `{"error": "error message"}`
  ///
  /// Memory is automatically freed after the call.
  String splitDiff(String diff, int lineLimit) {
    // Convert Dart string to C string
    final diffPtr = diff.toNativeUtf8();

    // Call Go function
    final resultPtr = _splitDiff(diffPtr, lineLimit);

    // Convert C string to Dart string
    final result = resultPtr.toDartString();

    // Free memory
    malloc.free(diffPtr);
    _freeString(resultPtr);

    return result;
  }

  /// Cleans up resources.
  ///
  /// Should be called when the bridge is no longer needed.
  /// Currently does nothing, but provided for future cleanup logic.
  void dispose() {
    // Cleanup if needed in the future
  }
}
