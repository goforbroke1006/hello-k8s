package main

import (
	"log"
	"net/http"
)

func main() {
	http.HandleFunc("/", func(writer http.ResponseWriter, request *http.Request) {
		writer.WriteHeader(http.StatusOK)
		writer.Write([]byte("Hello!"))
	})
	log.Fatalln(http.ListenAndServe(":8080", nil))
}
