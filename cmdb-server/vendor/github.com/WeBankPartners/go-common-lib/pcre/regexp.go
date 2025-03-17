package pcre

/*
   #cgo LDFLAGS: -lpcre
   #cgo CFLAGS: -I/opt/local/include
   #include <pcre.h>
   #include <string.h>
*/
import "C"

import (
	"fmt"
	"strconv"
	"unsafe"
)

// Flags for Compile and Match functions.
const (
	ANCHORED        = C.PCRE_ANCHORED
	BSR_ANYCRLF     = C.PCRE_BSR_ANYCRLF
	BSR_UNICODE     = C.PCRE_BSR_UNICODE
	NEWLINE_ANY     = C.PCRE_NEWLINE_ANY
	NEWLINE_ANYCRLF = C.PCRE_NEWLINE_ANYCRLF
	NEWLINE_CR      = C.PCRE_NEWLINE_CR
	NEWLINE_CRLF    = C.PCRE_NEWLINE_CRLF
	NEWLINE_LF      = C.PCRE_NEWLINE_LF
	NO_UTF8_CHECK   = C.PCRE_NO_UTF8_CHECK
)

// Flags for Compile functions
const (
	CASELESS          = C.PCRE_CASELESS
	DOLLAR_ENDONLY    = C.PCRE_DOLLAR_ENDONLY
	DOTALL            = C.PCRE_DOTALL
	DUPNAMES          = C.PCRE_DUPNAMES
	EXTENDED          = C.PCRE_EXTENDED
	EXTRA             = C.PCRE_EXTRA
	FIRSTLINE         = C.PCRE_FIRSTLINE
	JAVASCRIPT_COMPAT = C.PCRE_JAVASCRIPT_COMPAT
	MULTILINE         = C.PCRE_MULTILINE
	NO_AUTO_CAPTURE   = C.PCRE_NO_AUTO_CAPTURE
	UNGREEDY          = C.PCRE_UNGREEDY
	UTF8              = C.PCRE_UTF8
)

// Flags for Match functions
const (
	NOTBOL            = C.PCRE_NOTBOL
	NOTEOL            = C.PCRE_NOTEOL
	NOTEMPTY          = C.PCRE_NOTEMPTY
	NOTEMPTY_ATSTART  = C.PCRE_NOTEMPTY_ATSTART
	NO_START_OPTIMIZE = C.PCRE_NO_START_OPTIMIZE
	PARTIAL_HARD      = C.PCRE_PARTIAL_HARD
	PARTIAL_SOFT      = C.PCRE_PARTIAL_SOFT
)

var pcrePanicErr string = "pcre error: %s\n"

// A reference to a compiled regular expression.
// Use Compile or MustCompile to create such objects.
type Regexp struct {
	ptr []byte
}

// Number of bytes in the compiled pattern
func pcresize(ptr *C.pcre) (size C.size_t) {
	C.pcre_fullinfo(ptr, nil, C.PCRE_INFO_SIZE, unsafe.Pointer(&size))
	return
}

// Number of capture groups
func pcregroups(ptr *C.pcre) (count C.int) {
	C.pcre_fullinfo(ptr, nil,
		C.PCRE_INFO_CAPTURECOUNT, unsafe.Pointer(&count))
	return
}

// Move pattern to the Go heap so that we do not have to use a
// finalizer.  PCRE patterns are fully relocatable. (We do not use
// custom character tables.)
func toheap(ptr *C.pcre) (re Regexp) {
	defer C.free(unsafe.Pointer(ptr))
	size := pcresize(ptr)
	re.ptr = make([]byte, size)
	C.memcpy(unsafe.Pointer(&re.ptr[0]), unsafe.Pointer(ptr), size)
	return
}

// Try to compile the pattern.  If an error occurs, the second return
// value is non-nil.
func Compile(pattern string, flags int) (Regexp, *CompileError) {
	pattern1 := C.CString(pattern)
	defer C.free(unsafe.Pointer(pattern1))
	if clen := int(C.strlen(pattern1)); clen != len(pattern) {
		return Regexp{}, &CompileError{
			Pattern: pattern,
			Message: "NUL byte in pattern",
			Offset:  clen,
		}
	}
	var errptr *C.char
	var erroffset C.int
	ptr := C.pcre_compile(pattern1, C.int(flags), &errptr, &erroffset, nil)
	if ptr == nil {
		return Regexp{}, &CompileError{
			Pattern: pattern,
			Message: C.GoString(errptr),
			Offset:  int(erroffset),
		}
	}
	return toheap(ptr), nil
}

// Compile the pattern.  If compilation fails, panic.
func MustCompile(pattern string, flags int) (re Regexp, err error) {
	compileRe, compileErr := Compile(pattern, flags)
	if compileErr != nil {
		err = fmt.Errorf(compileErr.String())
	} else {
		re = compileRe
	}
	return
}

// Returns the number of capture groups in the compiled pattern.
func (re Regexp) Groups() int {
	if re.ptr == nil {
		fmt.Printf(pcrePanicErr, "Regexp.Groups: uninitialized")
		return 0
	}
	return int(pcregroups((*C.pcre)(unsafe.Pointer(&re.ptr[0]))))
}

// Matcher objects provide a place for storing match results.
// They can be created by the Matcher and MatcherString functions,
// or they can be initialized with Reset or ResetString.
type Matcher struct {
	re       Regexp
	groups   int
	ovector  []C.int // scratch space for capture offsets
	matches  bool    // last match was successful
	subjects string  // one of these fields is set to record the subject,
	subjectb []byte  // so that Group/GroupString can return slices
}

// Returns a new matcher object, with the byte array slice as a
// subject.
func (re Regexp) Matcher(subject []byte, flags int) (m *Matcher) {
	m = new(Matcher)
	m.Reset(re, subject, flags)
	return
}

// Returns a new matcher object, with the specified subject string.
func (re Regexp) MatcherString(subject string, flags int) (m *Matcher) {
	m = new(Matcher)
	m.ResetString(re, subject, flags)
	return
}

// Switches the matcher object to the specified pattern and subject.
func (m *Matcher) Reset(re Regexp, subject []byte, flags int) {
	if re.ptr == nil {
		fmt.Printf(pcrePanicErr, "Regexp.Matcher: uninitialized")
		return
	}
	m.init(re)
	m.Match(subject, flags)
}

// Switches the matcher object to the specified pattern and subject
// string.
func (m *Matcher) ResetString(re Regexp, subject string, flags int) {
	if re.ptr == nil {
		fmt.Printf(pcrePanicErr, "Regexp.Matcher: uninitialized")
		return
	}
	m.init(re)
	m.MatchString(subject, flags)
}

func (m *Matcher) init(re Regexp) {
	m.matches = false
	if m.re.ptr != nil && &m.re.ptr[0] == &re.ptr[0] {
		// Skip group count extraction if the matcher has
		// already been initialized with the same regular
		// expression.
		return
	}
	m.re = re
	m.groups = re.Groups()
	if ovectorlen := 3 * (1 + m.groups); len(m.ovector) < ovectorlen {
		m.ovector = make([]C.int, ovectorlen)
	}
}

var nullbyte = []byte{0}

// Tries to match the speficied byte array slice to the current
// pattern.  Returns true if the match succeeds.
func (m *Matcher) Match(subject []byte, flags int) bool {
	if m.re.ptr == nil {
		fmt.Printf(pcrePanicErr, "Regexp.Matcher: uninitialized")
		return false
	}
	length := len(subject)
	m.subjects = ""
	m.subjectb = subject
	if length == 0 {
		subject = nullbyte // make first character adressable
	}
	subjectptr := (*C.char)(unsafe.Pointer(&subject[0]))
	return m.match(subjectptr, length, flags)
}

// Tries to match the speficied subject string to the current pattern.
// Returns true if the match succeeds.
func (m *Matcher) MatchString(subject string, flags int) bool {
	if m.re.ptr == nil {
		fmt.Printf(pcrePanicErr, "Regexp.Matcher: uninitialized")
		return false
	}
	length := len(subject)
	m.subjects = subject
	m.subjectb = nil
	if length == 0 {
		subject = "\000" // make first character addressable
	}
	// The following is a non-portable kludge to avoid a copy
	subjectptr := *(**C.char)(unsafe.Pointer(&subject))
	return m.match(subjectptr, length, flags)
}

func (m *Matcher) match(subjectptr *C.char, length, flags int) bool {
	rc := C.pcre_exec((*C.pcre)(unsafe.Pointer(&m.re.ptr[0])), nil,
		subjectptr, C.int(length),
		0, C.int(flags), &m.ovector[0], C.int(len(m.ovector)))
	switch {
	case rc >= 0:
		m.matches = true
		return true
	case rc == C.PCRE_ERROR_NOMATCH:
		m.matches = false
		return false
	case rc == C.PCRE_ERROR_BADOPTION:
		fmt.Printf(pcrePanicErr, "match func invalid option flag")
		return false
	}
	fmt.Printf(pcrePanicErr, "unexepected return code from pcre_exec: "+strconv.Itoa(int(rc)))
	return false
}

// Returns true if a previous call to Matcher, MatcherString, Reset,
// ResetString, Match or MatchString succeeded.
func (m *Matcher) Matches() bool {
	return m.matches
}

// Returns the number of groups in the current pattern.
func (m *Matcher) Groups() int {
	return m.groups
}

// Returns true if the numbered capture group is present in the last
// match (performed by Matcher, MatcherString, Reset, ResetString,
// Match, or MatchString).  Group numbers start at 1.  A capture group
// can be present and match the empty string.
func (m *Matcher) Present(group int) bool {
	return m.ovector[2*group] >= 0
}

// Returns the numbered capture group of the last match (performed by
// Matcher, MatcherString, Reset, ResetString, Match, or MatchString).
// Group 0 is the part of the subject which matches the whole pattern;
// the first actual capture group is numbered 1.  Capture groups which
// are not present return a nil slice.
func (m *Matcher) Group(group int) []byte {
	start := m.ovector[2*group]
	end := m.ovector[2*group+1]
	if start >= 0 {
		if m.subjectb != nil {
			return m.subjectb[start:end]
		}
		return []byte(m.subjects[start:end])
	}
	return nil
}

// Returns the numbered capture group as a string.  Group 0 is the
// part of the subject which matches the whole pattern; the first
// actual capture group is numbered 1.  Capture groups which are not
// present return an empty string.
func (m *Matcher) GroupString(group int) string {
	start := m.ovector[2*group]
	end := m.ovector[2*group+1]
	if start >= 0 {
		if m.subjectb != nil {
			return string(m.subjectb[start:end])
		}
		return m.subjects[start:end]
	}
	return ""
}

func (m *Matcher) name2index(name string) (group int) {
	if m.re.ptr == nil {
		fmt.Printf(pcrePanicErr, "Matcher.Named: uninitialized")
		return 0
	}
	name1 := C.CString(name)
	defer C.free(unsafe.Pointer(name1))
	group = int(C.pcre_get_stringnumber(
		(*C.pcre)(unsafe.Pointer(&m.re.ptr[0])), name1))
	if group < 0 {
		fmt.Printf(pcrePanicErr, "Matcher.Named: unknown name: "+name)
		return 0
	}
	return
}

// Returns the value of the named capture group.  This is a nil slice
// if the capture group is not present.  Panics if the name does not
// refer to a group.
func (m *Matcher) Named(group string) []byte {
	return m.Group(m.name2index(group))
}

// Returns the value of the named capture group, or an empty string if
// the capture group is not present.  Panics if the name does not
// refer to a group.
func (m *Matcher) NamedString(group string) string {
	return m.GroupString(m.name2index(group))
}

// Returns true if the named capture group is present.  Panics if the
// name does not refer to a group.
func (m *Matcher) NamedPresent(group string) bool {
	return m.Present(m.name2index(group))
}

// Return the start and end of the first match, or nil if no match.
// loc[0] is the start and loc[1] is the end.
func (re *Regexp) FindIndex(bytes []byte, flags int) []int {
	m := re.Matcher(bytes, flags)
	if m.Match(bytes, flags) {
		return []int{int(m.ovector[0]), int(m.ovector[1])}
	}
	return nil
}

// Return a copy of a byte slice with pattern matches replaced by repl.
func (re Regexp) ReplaceAll(bytes, repl []byte, flags int) []byte {
	m := re.Matcher(bytes, 0)
	r := []byte{}
	for m.Match(bytes, flags) {
		r = append(append(r, bytes[:m.ovector[0]]...), repl...)
		bytes = bytes[m.ovector[1]:]
	}
	return append(r, bytes...)
}

// A compilation error, as returned by the Compile function.  The
// offset is the byte position in the pattern string at which the
// error was detected.
type CompileError struct {
	Pattern string
	Message string
	Offset  int
}

func (e *CompileError) String() string {
	return e.Pattern + " (" + strconv.Itoa(e.Offset) + "): " + e.Message
}
