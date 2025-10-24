package main

/*
#include <stdlib.h>
*/
import "C"
import (
	"encoding/json"
	"unsafe"
)

//export ListFilesFFI
func ListFilesFFI(pathCStr *C.char) *C.char {
	path := C.GoString(pathCStr)

	// Create a temporary App instance for the FFI call
	// Note: This creates a minimal app without Wails runtime context
	app := NewApp()

	// Call the existing ListFiles function
	files, err := app.ListFiles(path)
	if err != nil {
		return C.CString(marshalError(err))
	}

	// Marshal to JSON
	result, err := json.Marshal(files)
	if err != nil {
		return C.CString(marshalError(err))
	}

	return C.CString(string(result))
}

//export SplitDiffFFI
func SplitDiffFFI(diffCStr *C.char, lineLimitC C.int) *C.char {
	diff := C.GoString(diffCStr)
	lineLimit := int(lineLimitC)

	app := NewApp()
	splits, err := app.SplitShotgunDiff(diff, lineLimit)
	if err != nil {
		return C.CString(marshalError(err))
	}

	// Marshal to JSON
	result, err := json.Marshal(splits)
	if err != nil {
		return C.CString(marshalError(err))
	}

	return C.CString(string(result))
}

//export FreeString
func FreeString(str *C.char) {
	C.free(unsafe.Pointer(str))
}

// marshalError creates a JSON error response
func marshalError(err error) string {
	errObj := map[string]string{"error": err.Error()}
	bytes, _ := json.Marshal(errObj)
	return string(bytes)
}

// main function is required for building a shared library
func main() {}
