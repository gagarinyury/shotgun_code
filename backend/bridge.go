package main

/*
#include <stdlib.h>
*/
import "C"
import (
	"encoding/json"
	"fmt"
	"os"
	"os/exec"
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

//export ApplyPatchFFI
func ApplyPatchFFI(patchCStr *C.char, projectPathCStr *C.char, dryRunC C.int) *C.char {
	patch := C.GoString(patchCStr)
	projectPath := C.GoString(projectPathCStr)
	dryRun := dryRunC != 0

	result, err := applyPatchWithGit(patch, projectPath, dryRun)
	if err != nil {
		return C.CString(marshalError(err))
	}

	// Marshal result to JSON
	jsonResult, err := json.Marshal(result)
	if err != nil {
		return C.CString(marshalError(err))
	}

	return C.CString(string(jsonResult))
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

// ApplyResult represents the result of applying a patch
type ApplyResult struct {
	Success  bool     `json:"success"`
	Message  string   `json:"message"`
	Conflicts []string `json:"conflicts,omitempty"`
}

// applyPatchWithGit applies a patch using git apply command
func applyPatchWithGit(patch string, projectPath string, dryRun bool) (*ApplyResult, error) {
	// Create temporary patch file
	tmpFile, err := os.CreateTemp("", "patch-*.patch")
	if err != nil {
		return nil, fmt.Errorf("failed to create temp file: %w", err)
	}
	defer os.Remove(tmpFile.Name())

	// Write patch content
	if _, err := tmpFile.WriteString(patch); err != nil {
		return nil, fmt.Errorf("failed to write patch: %w", err)
	}
	tmpFile.Close()

	// Build git apply command
	args := []string{"apply"}
	if dryRun {
		args = append(args, "--check")
	}
	args = append(args, tmpFile.Name())

	cmd := exec.Command("git", args...)
	cmd.Dir = projectPath

	output, err := cmd.CombinedOutput()

	if err != nil {
		// Parse conflicts from git apply output
		return &ApplyResult{
			Success:  false,
			Message:  string(output),
			Conflicts: parseGitConflicts(string(output)),
		}, nil
	}

	return &ApplyResult{
		Success: true,
		Message: "Patch applied successfully",
	}, nil
}

// parseGitConflicts extracts conflict information from git apply error output
func parseGitConflicts(output string) []string {
	// TODO: Parse actual conflicts from git output
	// For now, return simple message
	if output != "" {
		return []string{output}
	}
	return []string{}
}

// main function is required for building a shared library
func main() {}
