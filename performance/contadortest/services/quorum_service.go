package services

import (
	"os"
	"strconv"
	"strings"

	"github.com/astaxie/beego/logs"
	"github.com/ethereum/go-ethereum/accounts/abi/bind"
	"github.com/ethereum/go-ethereum/ethclient"
	"github.com/ethereum/go-ethereum/rpc"
)

type QuorumServices struct {
	prefijo string
	host    string
	port    int
	log     logs.BeeLogger
}

func NewQuorumServices(prefijo string) QuorumServices {
	host := os.Getenv("QUORUM_HOST")
	var strport string
	var port int
	if len(host) == 0 {
		host = "127.0.0.1"
	}
	strport = os.Getenv("QUORUM_PORT")
	if len(strport) == 0 {
		port = 22000
	} else {
		port, _ = strconv.Atoi(strport)
	}
	newQuorumServices := QuorumServices{prefijo, host, port, *logs.GetBeeLogger()}
	return newQuorumServices
}

func (s QuorumServices) connectToQuorum() (*rpc.Client, error) {
	//logs.Trace("connectToQuorum: http://" + s.host + ":" + strconv.Itoa(s.port))
	return rpc.Dial("http://" + s.host + ":" + strconv.Itoa(s.port))
}

func (s QuorumServices) connectToQuorumEthclient() (*ethclient.Client, error) {
	//logs.Trace("connectToQuorum: http://" + s.host + ":" + strconv.Itoa(s.port))
	return ethclient.Dial("http://" + s.host + ":" + strconv.Itoa(s.port))
}

func (s QuorumServices) createTransactor() (*bind.TransactOpts, error) {
	auth, err := bind.NewTransactor(
		strings.NewReader("{\"address\":\"58b8527743f89389b754c63489262fdfc9ba9db6\",\"crypto\":{\"cipher\":\"aes-128-ctr\",\"ciphertext\":\"20f46e1aacd6bf28b66e37b5b6cf9b1cefc42ac8a4461e86893ae4ccd7e671c7\",\"cipherparams\":{\"iv\":\"4d455255a895091952f653c4b59c92c7\"},\"kdf\":\"scrypt\",\"kdfparams\":{\"dklen\":32,\"n\":262144,\"p\":1,\"r\":8,\"salt\":\"74b089663af7571962992c5a1bb68c1e82e5f8308c646b68cfe576c1c6f38d5c\"},\"mac\":\"5ce860f522494ff1322f776d93ee6fb149eb1cddb53722e2e59191c4d0bdd8c9\"},\"id\":\"2db34512-2c46-44b7-a8a9-6b73302dde1e\",\"version\":3}"),
		"Passw0rd")
	return auth, err
}
