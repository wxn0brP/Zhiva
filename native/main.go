package main

import (
	"fmt"
	"os"
	"strconv"
    webview "github.com/lexesv/go-webview-gui"
)

func main() {
	port := 8080
	if len(os.Args) < 2 {
		fmt.Printf("Usage: %s [port] [title]\n", os.Args[0])
		return
	}
	if p, err := strconv.Atoi(os.Args[1]); err == nil {
		port = p
	}
	title := "wxn0brP"
	if len(os.Args) > 2 {
		title = os.Args[2]
	}

    w := webview.New(true, true)
    defer w.Destroy()
    w.SetTitle(title)
    w.SetSize(1600, 900, webview.HintNone)
	w.Maximize()
    w.Navigate(fmt.Sprintf("http://localhost:%d", port))
    w.Run()
}
