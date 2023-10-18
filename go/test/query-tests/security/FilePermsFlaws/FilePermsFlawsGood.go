package main

import (
	"io/fs"
	"os"
	"runtime"
)

func getPermsGood(s bool) os.FileMode {
	switch runtime.GOOS {
	case "windows":
		if s {
			return 0400
		}
		return 0600
	}
	return 0777
}

const (
	FileModeMask os.FileMode = 0170000
	ModeSocket   os.FileMode = 0140000
	ModeSticky   os.FileMode = 0o1000
	Regular      os.FileMode = 0100644
)

func someMethod(x FileMode) {
	os.Chmod("./some-filename", x)
}

func filePermsFlawsGood(s bool) {
	if err := os.Chmod("./some-filename", 0644); err != nil {
		return
	}

	if err := os.Chmod("./some-filename", 0775); err != nil {
		return
	}

	if err := os.Chmod("./some-filename", 0777); err != nil {
		return
	}

	// false positives
	if err := os.Chmod("./some-filename", 0755|0666); err != nil {
		return
	}

	if err := os.MkdirAll("./some-dirname", 0o777); err != nil {
		return
	}

	if err := os.MkdirAll("./some-dirname", 0o7_7_7); err != nil {
		return
	}

	if err := os.MkdirAll("./some-dirname", 0o000777); err != nil {
		return
	}

	if err := os.Chmod("./some-filename", 075); err != nil {
		return
	}

	if err := os.MkdirAll("./some-dirname", 0o01); err != nil {
		return
	}

	if err := os.MkdirAll("./some-dirname", 0o7); err != nil {
		return
	}

	if err := os.MkdirAll("./some-dirname", 0o0); err != nil {
		return
	}

	if err := os.MkdirAll("./some-dirname", 0); err != nil {
		return
	}

	if err := os.MkdirAll("./some-dirname", 00); err != nil {
		return
	}

	if err := os.MkdirAll("./some-dirname", 1); err != nil {
		return
	}

	if err := os.MkdirAll("./some-dirname", 0x1); err != nil {
		return
	}

	if err := os.MkdirAll("./some-dirname", 0o0700); err != nil {
		return
	}

	if err := os.Chmod("./some-filename", 0000); err != nil {
		return
	}

	if err := os.Chmod("./some-filename", 0755|os.ModeSticky); err != nil {
		return
	}

	if err := os.Mkdir("./some-dirname", 0755|os.ModeSticky); err != nil {
		return
	}

	if err := os.Mkdir("./some-dirname", 0o755|os.ModeSticky); err != nil {
		return
	}

	if err := os.Mkdir("./some-dirname", 0o001|os.ModeSticky); err != nil {
		return
	}

	if err := os.Chmod("./some-filename", 0111|os.ModeSetuid|0123&os.ModeSetgid); err != nil {
		return
	}

	// consts
	if err := os.MkdirAll("./some-dirname", fs.ModeDevice); err != nil {
		return
	}

	// file type codes like S_IFCHR
	fi, _ := os.Stat("./some-other-dir")
	if err := os.MkdirAll("./some-dirname", fi.Mode()); err != nil {
		return
	}

	if fi.Mode()&0x1000 == 0x1000 ||
		fi.Mode()&0x2000 == 0x2000 ||
		fi.Mode()&0x6000 == 0x6000 {
		return
	}

	// common octals encoded as decimals
	if err := os.MkdirAll("./some-dirname", 420); err != nil {
		return
	}

	if err := os.MkdirAll("./some-dirname", 436|511&509|493|438|436|420|365); err != nil {
		return
	}

	if err := os.MkdirAll("./some-dirname", 0x1a4|0x1ed); err != nil {
		return
	}

	// indirect
	if err := os.Chmod("./some-filename", getPermsGood(s)); err != nil {
		return
	}

	// custom method with more than 9 bits
	someMethod(0o2777)
}

func main() {
	filePermsFlawsGood(true)
}
