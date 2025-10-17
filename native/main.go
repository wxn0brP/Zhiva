package main

import (
	"fmt"
	"os"
	"strings"
	webview "github.com/lexesv/go-webview-gui"
)

func main() {
	if len(os.Args) < 2 {
		fmt.Printf("Usage: %s <port>\nExample: %s 8080\n", os.Args[0], os.Args[0])
		return
	}
	target := os.Args[1]

	if !strings.Contains(target, "://") {
		target = "http://localhost:" + target
	}

	w := webview.New(true, true)
	defer w.Destroy()
	w.SetTitle("wxn0brP")
	w.SetSize(1600, 900, webview.HintNone)
	w.Maximize()

	w.Bind("zhiva_setWindowTitle", func(newTitle string) {
		w.Dispatch(func() {
			w.SetTitle(newTitle)
		})
	})
	w.Bind("zhiva_isApp", func() bool { return true })
	w.Bind("zhiva_closeApp", func() { w.Dispatch(w.Terminate) })

	w.Navigate(target)
	w.Run()
}