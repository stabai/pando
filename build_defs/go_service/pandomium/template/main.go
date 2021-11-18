package main

import (
	"flag"
	"fmt"
	"google.golang.org/grpc"
	"log"
	"net"
	"os"
	"strconv"
	pb "{SERVICE_CONTRACT_GO_IMPORTPATH}"
)

type PandomiumServer struct {
	pb.Unimplemented{SERVICE_NAME}Server
}

var (
	port = flag.Int("port", 50051, "The server port")
)

func main() {
	configPort := os.Getenv("GRPC_PORT")
	port, err := strconv.Atoi(configPort)
	if err != nil {
		port = 50051
	}
	lis, err := net.Listen("tcp", fmt.Sprintf("localhost:%d", port))
	if err != nil {
	log.Fatalf("failed to listen: %v", err)
	}
	s := grpc.NewServer()
	registerServices(s)
	log.Printf("server listening at %v", lis.Addr())
	if err := s.Serve(lis); err != nil {
	log.Fatalf("failed to serve: %v", err)
	}
}

func registerServices(s *grpc.Server) {
	pb.Register{SERVICE_NAME}Server(s, &PandomiumServer{})
}
