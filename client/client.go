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

var (
	ip      = "127.0.0.1:31315"
	network = "tcp"
)

func main() {
	f, err := os.Open("address")
	if err != nil {
		log.Println("using defaut address")
	} else {
		data := make([]byte, 100)
		len, err := f.Read(data)
		if err != nil {
			log.Println(err, "\nusing defaut address")
		}
		ip = string(data[:len])
	}
	client()
}

type msg struct {
	Dst  string    `json:"dst"`
	Text string    `json:"text"`
	Date time.Time `json:"date"`
}

func client() {
	conn, err := net.Dial(network, ip)
	conn.SetDeadline(time.Now().Add(10 * time.Second))
	defer conn.Close()
	if err != nil {
		log.Fatal(err)
	} else {
		log.Println("connected")
	}

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
	//mb := *(*[]byte)(unsafe.Pointer(&m))
}

func send(m *msg, conn net.Conn) {
	jb, err := json.Marshal(m)
	if err != nil {
		fmt.Println(err)
		return
	}
	str := string(jb)
	_, err = fmt.Fprintf(conn, str+"\n")
	if err != nil {
		fmt.Println(err)
		return
	}
	fmt.Println("written")
	time.Sleep(time.Second * 1)
}

func listen(conn net.Conn) {
	for {
		resp, err := bufio.NewReader(conn).ReadString('\n')
		if err != nil {
			fmt.Println(err)
			return
		}
		fmt.Println(resp)
	}
}
