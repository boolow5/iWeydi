package main

import "net/http"

func NotFoundHandler(w http.ResponseWriter, r *http.Request) {
	w.Write([]byte("404 - NOT FOUND"))
}

func InternalErrorHandler(w http.ResponseWriter, r *http.Request) {
	w.Write([]byte("500 - INTERNAL ERROR"))
}
