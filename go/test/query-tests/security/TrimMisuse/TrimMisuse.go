package main

import (
	"bytes"
	"fmt"
	"os"
	"strings"
)

const w string = ":tob:"

// finding
func test1() {
	fmt.Println(strings.TrimRight("ABBA", "BBA"))
	fmt.Println(bytes.TrimRight([]byte("ABBA"), "BBA"))
}

// finding
func test2(unknown string) {
	a := "/test"
	fmt.Println(strings.TrimRight(unknown, a))
}

// finding
func test3(a string) {
	fmt.Println(strings.TrimLeft("ABBA", a))
	fmt.Println(bytes.TrimLeft([]byte("ABBA"), a))
}

// finding
func test4(a string) {
	fmt.Println(strings.Trim("QWE", w))
}

// finding, repeated characters
func test5() {
	fmt.Println(strings.TrimLeft(" ABBA", "  "))
	fmt.Println(bytes.TrimLeft([]byte(" ABBA"), "  "))
}

/*
 * False positives
 */

// ok
func test_fp1() {
	fmt.Println(strings.TrimRight("ABBA", "B"))
	fmt.Println(bytes.TrimRight([]byte("ABBA"), "B"))
}

// ok
func test_fp2(unknown string) {
	fmt.Println(strings.TrimRight(unknown, "\n\r"))
}

// ok
func test_fp3() {
	fmt.Println(strings.TrimRight("ABBA", "\r\n"))
}

// ok
func test_fp4() {
	fmt.Println(strings.Trim("QWE", "!@#$%^x"))
}

// ok
func test_fp5(a string) {
	fmt.Println(strings.Trim("ABBA", a))
}

// ok
func test_fp6() {
	fmt.Println(strings.TrimLeft("ABBA", "  \t\n"))
}

// ok; TODO - handle concatenation
func test_fp7(a string) {
	fmt.Println(strings.TrimLeft(a, a+"/tmp"))
}

// ok; only not-word characters
func test_fp8(a string) {
	fmt.Println(strings.TrimRight(a, ";'\" "))
	fmt.Println(strings.TrimRight(a, "({}!$#@:<"))
	fmt.Println(bytes.TrimRight([]byte(a), "({}!$#@:<"))
}

// ok
func test_fp9() {
	fmt.Println(strings.Trim("QWE", " \nx"))
}

func main() {
	test1()
	test2(os.Args[0])
	test3("removeall")
	test4("p")
	test5()

	test_fp1()
	test_fp2(os.Args[0])
	test_fp3()
	test_fp4()
	test_fp5("X")
	test_fp6()
	test_fp7(os.Args[0])
	test_fp8(os.Args[0])
	test_fp9()
}
