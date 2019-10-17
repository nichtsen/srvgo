package main

import (
	"bufio"
	"log"
	"net"
	"strconv"
	"time"
)

var (
	ip      = "0.0.0.0:31315"
	network = "tcp"
	count   = 0
)

func main() {
	server()
}

func server() {
	lnr, err := net.Listen(network, ip)
	defer lnr.Close()
	if err != nil {
		log.Fatal(err)
	} else {
		log.Println("Listening...")
	}
	for {
		conn, err := lnr.Accept()
		defer conn.Close()
		if err != nil {
			log.Println(err)
		} else {
			conn.SetDeadline(time.Now().Add(60 * time.Second))
			go handleConnection(conn)
		}
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
