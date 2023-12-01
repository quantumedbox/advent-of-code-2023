package main

import (
	"strconv"
	"unicode"
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
		var first, last rune
		firstFound := false

		for _, char := range fileScanner.Text() {
			if !unicode.IsDigit(char) {
				continue
			}

			last = char

			if !firstFound {
				firstFound = true
				first = char
			}
		}

		number, err := strconv.Atoi(string(first) + string(last))
		if err != nil {
			panic("Invalid number")
		}

		result += number
	}

	fmt.Println(result);
}
