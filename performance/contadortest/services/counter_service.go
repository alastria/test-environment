package services

import (
	"math/big"
	"strconv"
	"strings"

	"github.com/astaxie/beego"

	"github.com/ethereum/go-ethereum/accounts/abi/bind"
	"github.com/ethereum/go-ethereum/common"
	"github.com/ethereum/go-ethereum/ethclient"

	"github.com/alastria/test-environment/contadortest/services/bindings"
)

type CounterQuorumService struct {
	QuorumServices
	contractAddress string
}

func NewCounterQuorumService() CounterQuorumService {
	prefijo := beego.BConfig.RunMode + "::"
	return NewCounterQuorumServiceAddress(beego.AppConfig.String(prefijo+"quorum.CounterAddress"),
		prefijo)
}

func NewCounterQuorumServiceAddress(address string, prefijo string) CounterQuorumService {
	var err error

	newnetwork := CounterQuorumService{
		NewQuorumServices(prefijo),
		address}
	if err != nil {
		newnetwork.log.Error("CounterQuorumService no inicializada correctamente.", err)
	}
	return newnetwork
}

func (n CounterQuorumService) Init() (wasOk bool, err error) {
	//n.log.Debug("CounterQuorumService - Init")

	wasOk = true
	//n.log.Debug("CounterQuorumService - End: %v", wasOk, err)
	return wasOk, err
}

func (n CounterQuorumService) Add() (err error) {
	//n.log.Debug("Counter")
	var transactor *bind.TransactOpts
	var contract *bindings.TestAlastriaCounter

	transactor, err = n.createTransactor()
	if err == nil {
		contract, err = n.getContract()
		if err == nil {
			_, err = contract.Add(transactor)

		}
	}
	return err
}

func (n CounterQuorumService) Substract() (err error) {
	//n.log.Debug("Counter")
	var transactor *bind.TransactOpts
	var contract *bindings.TestAlastriaCounter

	transactor, err = n.createTransactor()
	if err == nil {
		contract, err = n.getContract()
		if err == nil {
			_, err = contract.Subtract(transactor)
		}
	}
	return err
}

func (n CounterQuorumService) Get() (cuantas *big.Int, err error) {
	//n.log.Debug("LeerCountercion")

	var contract *bindings.TestAlastriaCounter

	contract, err = n.getContract()
	if err == nil {
		cuantas, err = contract.Get(&bind.CallOpts{})
	}

	return cuantas, err
}

func (n CounterQuorumService) DeployCounterContract() (string, error) {
	//n.log.Debug("CounterQuorumService - DeployCounterContract")
	client, err := n.connectToQuorumEthclient()
	if err == nil {
		transactor, err := n.createTransactor()

		if err == nil {
			var cuantas *big.Int = big.NewInt(0)
			// Deploy a new awesome contract for the binding demo
			address, _, Counter, err := bindings.DeployTestAlastriaCounter(transactor, client, cuantas)

			if err != nil || Counter == nil {
				n.log.Error("Failed to deploy new Counter contract: %v", err)
				return "", err
			}
			//n.log.Debug("Contract pending deploy: ", strings.ToLower(address.Hex()))
			//n.log.Debug("Transaction waiting to be mined: ", strings.ToLower(tx.Hash().Hex()))

			n.contractAddress = strings.ToLower(address.Hex())
		}
	}
	// Don't even wait, check its presence in the local pending state
	/*time.Sleep(250 * time.Millisecond)*/ // Allow it to be processed by the local node :P
	return n.contractAddress, err
}

func (n CounterQuorumService) getContract() (contract *bindings.TestAlastriaCounter, err error) {
	//n.log.Trace("CounterQuorumService - setContract")
	var client *ethclient.Client

	client, err = n.connectToQuorumEthclient()
	if err == nil {
		if contract == nil {
			contract, err =
				bindings.NewTestAlastriaCounter(
					common.HexToAddress(n.contractAddress), client)
		}
	}

	if err != nil {
		n.log.Debug("Object resume: %v", n.toString())
		n.log.Error("Failed to connect to the Ethereum client: %v", err)
	}
	return contract, err
}

func (n CounterQuorumService) ContractAddress() string {
	return n.contractAddress
}

func (n CounterQuorumService) toString() (salida string) {
	salida = "{"
	salida += "'Host': \"" + n.host + "\", "
	salida += "'Port': \"" + strconv.Itoa(n.port) + "\", "
	salida += "'ContractAddress': \"" + n.contractAddress + "\", "
	salida += "'Prefijo': \"" + string(n.prefijo) + "\""
	salida += "}"
	return salida
}
