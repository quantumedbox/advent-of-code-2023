package main

import (
	"strings"
	"bufio"
	"fmt"
	"os"
)

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
		var first, last int
		var firstIdx, lastIdx int

		line := fileScanner.Text()

		if firstIdx = strings.IndexAny(line, "0123456789"); firstIdx != -1 {
			first = int(line[firstIdx]) - 0x30
		}

		if lastIdx = strings.LastIndexAny(line, "0123456789"); lastIdx != -1 {
			last = int(line[lastIdx]) - 0x30
		}

		for i, word := range [9]string{"one", "two", "three", "four", "five", "six", "seven", "eight", "nine"} {
			if t := strings.Index(line, word); t != -1 && (t < firstIdx || firstIdx == -1) {
				firstIdx = t
				first = i + 1
			}

			if t := strings.LastIndex(line, word); t != -1 && t > lastIdx {
				lastIdx = t
				last = i + 1
			}
		}

		result += first * 10 + last
	}

	fmt.Println(result);
}
