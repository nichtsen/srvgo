package main

import (
	"bufio"
	"encoding/json"
	"fmt"
	"log"
	"net"
	"os"
	"time"
)

//NETWORK default network
const NETWORK = "tcp"

var ip = "127.0.0.1:31315"

type msg struct {
	Dst  string    `json:"dst"`
	Text string    `json:"text"`
	Date time.Time `json:"date"`
}

func client() {
	conn, err := net.Dial(NETWORK, ip)
	if err != nil {
		log.Fatal(err)
	}
	log.Println("Connected with server!")
	defer conn.Close()
	conn.SetDeadline(time.Now().Add(10 * time.Second))

	go listen(conn)

	m := &msg{
		Dst:  ip,
		Text: "Message",
		Date: time.Now(),
	}
	for i := 1; i <= 10; i++ {
		m.Date = time.Now()
		send(m, conn)
	}
}

func send(m *msg, conn net.Conn) {
	jb, err := json.Marshal(m)
	if err != nil {
		log.Println(err)
		return
	}
	str := string(jb)
	_, err = fmt.Fprintf(conn, str+"\n")
	if err != nil {
		log.Println(err)
		return
	}
	log.Println("Message has been written!")
	time.Sleep(time.Second * 1)
}

func listen(conn net.Conn) {
	for {
		resp, err := bufio.NewReader(conn).ReadString('\n')
		if err != nil {
			log.Println(err)
			return
		}
		log.Println(resp)
	}
}

func main() {
	f, err := os.Open("address")
	if err != nil {
		log.Println("Using defaut address")
	} else {
		data := make([]byte, 100)
		len, err := f.Read(data)
		if err != nil {
			log.Println(err, "Using defaut address")
		}
		ip = string(data[:len])
	}
	client()
}
