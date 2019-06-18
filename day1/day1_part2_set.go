package main

import (
	"bufio"
	"fmt"
	"log"
	"os"
	"strconv"
)

func main() {
	file, err := os.Open("frequencies2.txt")
	if err != nil {
		log.Fatal(err)
	}
	defer file.Close()

	scanner := bufio.NewScanner(file)
	for scanner.Scan() {
		if s, err := strconv.ParseFloat(scanner.Text(), 32); err == nil {
			fmt.Println(s)
		}
	}

	if err := scanner.Err(); err != nil {
		log.Fatal(err)
	}
}
