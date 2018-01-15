package main

// generate some random bytes for a key and print them so they can
// be put in a byte array

import (
	"crypto/rand"
	"fmt"
)

func main() {
	var key [32]byte
	if _, err := rand.Read(key[:]); err != nil {
		panic(err)
	}
	for _, b := range key {
		fmt.Printf("0x%02x, ", b)
	}
	fmt.Print("\n")
}
