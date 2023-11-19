package main

import (
	"bufio"
	"log"
	"net"
	"strconv"
	"time"
)

const (
	DEFAULT_PORT = ":31315"
	NETWORK      = "tcp4"
)

var count = 0

func server() {
	lnr, err := net.Listen(NETWORK, DEFAULT_PORT)
	if err != nil {
		log.Fatal(err)
	}
	log.Println("Listening...")
	defer lnr.Close()
	for {
		conn, err := lnr.Accept()
		if err != nil {
			log.Println(err)
			break
		}
		defer conn.Close()
		conn.SetDeadline(time.Now().Add(60 * time.Second))
		go handleConnection(conn)
	}
}

func handleConnection(conn net.Conn) {
	for {
		msg, err := bufio.NewReader(conn).ReadString('\n')
		if err != nil {
			log.Println(err)
			break
		}
		count++
		log.Println("received: ", msg, "\n", "Remote Address: ", conn.RemoteAddr())
		conn.Write([]byte("server(" + conn.LocalAddr().String() + ")[" + strconv.Itoa(count) + "]: " + msg + "\n"))
	}
}

func main() {
	server()
}
