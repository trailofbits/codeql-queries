package main

import (
	"os"
	"runtime"
)

func getPerms(s bool) os.FileMode {
	switch runtime.GOOS {
	case "windows":
		/* TODO: we should detect these */
		if s {
			return 0644
		}
		return 0200
	}

	// bug
	return 777
}

func filePermsFlaws(s bool) {
	// bugs
	if err := os.Chmod("./some-filename", 644); err != nil {
		return
	}

	if err := os.Chmod("./some-filename", 775); err != nil {
		return
	}

	if err := os.Chmod("./some-filename", 7_7_5); err != nil {
		return
	}

	if err := os.Chmod("./some-filename", 0x44); err != nil {
		return
	}

	if err := os.Chmod("./some-filename", 0x777); err != nil {
		return
	}

	/* Go accepts only 9 bits on all platforms */
	if err := os.Mkdir("./some-filename", 02755); err != nil {
		return
	}

	if err := os.Mkdir("./some-filename", 04666); err != nil {
		return
	}

	if err := os.Mkdir("./some-filename", 07777); err != nil {
		return
	}

	// should work on Linux, but not on OSX
	if err := os.Chmod("./some-filename", 0o1755); err != nil {
		return
	}

	if err := os.Chmod("./some-filename", 04666); err != nil {
		return
	}

	if err := os.Chmod("./some-filename", 07777); err != nil {
		return
	}

	/* combined permissions */
	if err := os.Chmod("./some-filename", 0755|0b_1_1|0666); err != nil {
		return
	}

	if err := os.Chmod("./some-filename", 0x0755|0b11|0222|0|0x12); err != nil {
		return
	}

	if err := os.Chmod("./some-filename", 0111|os.ModeSetuid|123&os.ModeSetgid); err != nil {
		return
	}

	fi, _ := os.Stat("./some-other-dir")
	if fi.Mode()&755 == 755 {
		return
	}

	if err := os.MkdirAll("./some-dirname", fi.Mode()|0x1000); err != nil {
		return
	}

	if err := os.MkdirAll("./some-dirname", fi.Mode()|0x2000); err != nil {
		return
	}
}

func main() {
	filePermsFlaws(true)
}
