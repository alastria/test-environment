package main

import (
	"fmt"
	"math/big"
	"os"
	"strconv"
	"time"

	"github.com/alastria/test-environment/contadortest/services"
	"github.com/astaxie/beego/logs"
)

const waitForMining = 1

var contadortest services.CounterQuorumService
var log *logs.BeeLogger = logs.GetBeeLogger()

func main() {

	argsWithoutProg := os.Args[1:]

	switch argsWithoutProg[0] {
	case "deploy":
		doDeploy(argsWithoutProg)

		break
	case "add":
		doAdd(argsWithoutProg)

		break
	case "substract":
		doSubstract(argsWithoutProg)

		break
	case "get":
		doGet(argsWithoutProg)

		break
	case "test-multi":
		log.Trace("Iniciando el test-multi")
		numero_transacciones, err := strconv.ParseUint(argsWithoutProg[1], 10, 64)
		if err == nil {
			address, err := doDeploy(argsWithoutProg)
			time.Sleep(waitForMining * time.Millisecond)
			if err == nil {
				argsWithoutProg[1] = address
				var cont uint64
				for cont = 0; cont < numero_transacciones; cont++ {
					log.Debug("Paso %v/%v", cont, numero_transacciones)
					err = doAdd(argsWithoutProg)
				}
				doGet(argsWithoutProg)
			}
		}
		log.Trace("Finalizando el test-multi")

		break
	default:
		fmt.Println("Forma de uso: \n contadortest deploy \n contadortest add <contract_address> \n contadortest substract <contract_address> \n contadortest get <contract_address>  \n contadortest test-multi <numero_transacciones> ")
	}

}

func doDeploy(argsWithoutProg []string) (address string, err error) {
	log.Trace("Realizando el deploy del contrato")
	contadortest = services.NewCounterQuorumService()
	address, err = contadortest.DeployCounterContract()
	if err == nil {
		log.Debug("Operación realizada con éxito. address = %s", address)
	} else {
		log.Warning("Error: ", err)
	}
	log.Trace("Finalizando el deploy del contrato")
	return
}

func doAdd(argsWithoutProg []string) (err error) {
	log.Trace("Iniciando doAdd")
	contadortest = services.NewCounterQuorumServiceAddress(argsWithoutProg[1], "")

	err = contadortest.Add()
	if err != nil {
		log.Warning("Error: ", err)
	} else {
		log.Debug("Operación realizada con éxito.")
	}

	log.Trace("Terminando doAdd")

	return
}

func doSubstract(argsWithoutProg []string) (err error) {
	log.Trace("Iniciando doSubstract")
	contadortest = services.NewCounterQuorumServiceAddress(argsWithoutProg[1], "")

	err = contadortest.Substract()

	if err == nil {
		log.Debug("Operación realizada con éxito.")
	} else {
		log.Warning("Error: ", err)
	}
	log.Trace("Finalizando doSubstract")

	return
}

func doGet(argsWithoutProg []string) {
	log.Trace("Iniciando doGet")

	total, err := get(argsWithoutProg)
	if err == nil {
		log.Debug(fmt.Sprintf("Total actual: %s", total))
	} else {
		log.Warning("Error: ", err)
	}
	log.Trace("Finalizando doGet")
}

func get(argsWithoutProg []string) (*big.Int, error) {
	contadortest = services.NewCounterQuorumServiceAddress(argsWithoutProg[1], "")

	return contadortest.Get()
}
