package main

import (
	"strings"
	"bufio"
	"fmt"
	"os"
)

var words = [9]string{"one", "two", "three", "four", "five", "six", "seven", "eight", "nine"}

func main() {
	readFile, err := os.Open("input")
	if err != nil {
		panic("Cannot read file");
	}

	defer readFile.Close()

	fileScanner := bufio.NewScanner(readFile)
	fileScanner.Split(bufio.ScanLines)

	result := 0

	for fileScanner.Scan() {
		var first, last rune
		var firstIdx, lastIdx int

		line := fileScanner.Text()

		if firstIdx = strings.IndexAny(line, "0123456789"); firstIdx != -1 {
			first = rune(line[firstIdx])
		}

		if lastIdx = strings.LastIndexAny(line, "0123456789"); lastIdx != -1 {
			last = rune(line[lastIdx])
		}

		for i, word := range words {
			if t := strings.Index(line, word); t != -1 && (t < firstIdx || firstIdx == -1) {
				firstIdx = t
				first = rune(i + 1 + 0x30)
			}

			if t := strings.LastIndex(line, word); t != -1 && t > lastIdx {
				lastIdx = t
				last = rune(i + 1 + 0x30)
			}
		}

		number := (int(first) - 0x30) * 10 + int(last) - 0x30

		result += number
	}

	fmt.Println(result);
}
