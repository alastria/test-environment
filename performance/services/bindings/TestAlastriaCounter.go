// Code generated - DO NOT EDIT.
// This file is a generated binding and any manual changes will be lost.

package bindings

import (
	"math/big"
	"strings"

	"github.com/ethereum/go-ethereum/accounts/abi"
	"github.com/ethereum/go-ethereum/accounts/abi/bind"
	"github.com/ethereum/go-ethereum/common"
	"github.com/ethereum/go-ethereum/core/types"
)

// TestAlastriaCounterABI is the input ABI used to generate the binding from.
const TestAlastriaCounterABI = "[{\"constant\":true,\"inputs\":[],\"name\":\"value\",\"outputs\":[{\"name\":\"\",\"type\":\"uint256\"}],\"payable\":false,\"stateMutability\":\"view\",\"type\":\"function\"},{\"constant\":false,\"inputs\":[],\"name\":\"add\",\"outputs\":[],\"payable\":false,\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"constant\":true,\"inputs\":[],\"name\":\"get\",\"outputs\":[{\"name\":\"retVal\",\"type\":\"uint256\"}],\"payable\":false,\"stateMutability\":\"view\",\"type\":\"function\"},{\"constant\":false,\"inputs\":[],\"name\":\"subtract\",\"outputs\":[],\"payable\":false,\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"inputs\":[{\"name\":\"initVal\",\"type\":\"uint256\"}],\"payable\":false,\"stateMutability\":\"nonpayable\",\"type\":\"constructor\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":false,\"name\":\"message\",\"type\":\"string\"},{\"indexed\":false,\"name\":\"newVal\",\"type\":\"uint256\"}],\"name\":\"Change\",\"type\":\"event\"}]"

// TestAlastriaCounterBin is the compiled bytecode used for deploying new contracts.
const TestAlastriaCounterBin = `6060604052341561000f57600080fd5b6040516020806102db83398101604052808051906020019091905050806000819055507fbb1cb5be1009ed69d54a8f3da20ed253be50c4dbbcade4f0a12114dedd9be5d78160405180806020018381526020018281038252600b8152602001807f696e697469616c697a65640000000000000000000000000000000000000000008152506020019250505060405180910390a150610229806100b26000396000f300606060405260043610610062576000357c0100000000000000000000000000000000000000000000000000000000900463ffffffff1680633fa4f245146100675780634f2be91f146100905780636d4ce63c146100a55780636deebae3146100ce575b600080fd5b341561007257600080fd5b61007a6100e3565b6040518082815260200191505060405180910390f35b341561009b57600080fd5b6100a36100e9565b005b34156100b057600080fd5b6100b861016e565b6040518082815260200191505060405180910390f35b34156100d957600080fd5b6100e1610177565b005b60005481565b60008081548092919060010191905055507fbb1cb5be1009ed69d54a8f3da20ed253be50c4dbbcade4f0a12114dedd9be5d76000546040518080602001838152602001828103825260038152602001807f61646400000000000000000000000000000000000000000000000000000000008152506020019250505060405180910390a1565b60008054905090565b6000808154809291906001900391905055507fbb1cb5be1009ed69d54a8f3da20ed253be50c4dbbcade4f0a12114dedd9be5d76000546040518080602001838152602001828103825260098152602001807f73756273747261637400000000000000000000000000000000000000000000008152506020019250505060405180910390a15600a165627a7a72305820e23fb6af9bff3f6d30d26e21b7b58aed2451a10c2204bd3605a165907c19f8f60029`

// DeployTestAlastriaCounter deploys a new Ethereum contract, binding an instance of TestAlastriaCounter to it.
func DeployTestAlastriaCounter(auth *bind.TransactOpts, backend bind.ContractBackend, initVal *big.Int) (common.Address, *types.Transaction, *TestAlastriaCounter, error) {
	parsed, err := abi.JSON(strings.NewReader(TestAlastriaCounterABI))
	if err != nil {
		return common.Address{}, nil, nil, err
	}
	address, tx, contract, err := bind.DeployContract(auth, parsed, common.FromHex(TestAlastriaCounterBin), backend, initVal)
	if err != nil {
		return common.Address{}, nil, nil, err
	}
	return address, tx, &TestAlastriaCounter{TestAlastriaCounterCaller: TestAlastriaCounterCaller{contract: contract}, TestAlastriaCounterTransactor: TestAlastriaCounterTransactor{contract: contract}}, nil
}

// TestAlastriaCounter is an auto generated Go binding around an Ethereum contract.
type TestAlastriaCounter struct {
	TestAlastriaCounterCaller     // Read-only binding to the contract
	TestAlastriaCounterTransactor // Write-only binding to the contract
}

// TestAlastriaCounterCaller is an auto generated read-only Go binding around an Ethereum contract.
type TestAlastriaCounterCaller struct {
	contract *bind.BoundContract // Generic contract wrapper for the low level calls
}

// TestAlastriaCounterTransactor is an auto generated write-only Go binding around an Ethereum contract.
type TestAlastriaCounterTransactor struct {
	contract *bind.BoundContract // Generic contract wrapper for the low level calls
}

// TestAlastriaCounterSession is an auto generated Go binding around an Ethereum contract,
// with pre-set call and transact options.
type TestAlastriaCounterSession struct {
	Contract     *TestAlastriaCounter // Generic contract binding to set the session for
	CallOpts     bind.CallOpts        // Call options to use throughout this session
	TransactOpts bind.TransactOpts    // Transaction auth options to use throughout this session
}

// TestAlastriaCounterCallerSession is an auto generated read-only Go binding around an Ethereum contract,
// with pre-set call options.
type TestAlastriaCounterCallerSession struct {
	Contract *TestAlastriaCounterCaller // Generic contract caller binding to set the session for
	CallOpts bind.CallOpts              // Call options to use throughout this session
}

// TestAlastriaCounterTransactorSession is an auto generated write-only Go binding around an Ethereum contract,
// with pre-set transact options.
type TestAlastriaCounterTransactorSession struct {
	Contract     *TestAlastriaCounterTransactor // Generic contract transactor binding to set the session for
	TransactOpts bind.TransactOpts              // Transaction auth options to use throughout this session
}

// TestAlastriaCounterRaw is an auto generated low-level Go binding around an Ethereum contract.
type TestAlastriaCounterRaw struct {
	Contract *TestAlastriaCounter // Generic contract binding to access the raw methods on
}

// TestAlastriaCounterCallerRaw is an auto generated low-level read-only Go binding around an Ethereum contract.
type TestAlastriaCounterCallerRaw struct {
	Contract *TestAlastriaCounterCaller // Generic read-only contract binding to access the raw methods on
}

// TestAlastriaCounterTransactorRaw is an auto generated low-level write-only Go binding around an Ethereum contract.
type TestAlastriaCounterTransactorRaw struct {
	Contract *TestAlastriaCounterTransactor // Generic write-only contract binding to access the raw methods on
}

// NewTestAlastriaCounter creates a new instance of TestAlastriaCounter, bound to a specific deployed contract.
func NewTestAlastriaCounter(address common.Address, backend bind.ContractBackend) (*TestAlastriaCounter, error) {
	contract, err := bindTestAlastriaCounter(address, backend, backend)
	if err != nil {
		return nil, err
	}
	return &TestAlastriaCounter{TestAlastriaCounterCaller: TestAlastriaCounterCaller{contract: contract}, TestAlastriaCounterTransactor: TestAlastriaCounterTransactor{contract: contract}}, nil
}

// NewTestAlastriaCounterCaller creates a new read-only instance of TestAlastriaCounter, bound to a specific deployed contract.
func NewTestAlastriaCounterCaller(address common.Address, caller bind.ContractCaller) (*TestAlastriaCounterCaller, error) {
	contract, err := bindTestAlastriaCounter(address, caller, nil)
	if err != nil {
		return nil, err
	}
	return &TestAlastriaCounterCaller{contract: contract}, nil
}

// NewTestAlastriaCounterTransactor creates a new write-only instance of TestAlastriaCounter, bound to a specific deployed contract.
func NewTestAlastriaCounterTransactor(address common.Address, transactor bind.ContractTransactor) (*TestAlastriaCounterTransactor, error) {
	contract, err := bindTestAlastriaCounter(address, nil, transactor)
	if err != nil {
		return nil, err
	}
	return &TestAlastriaCounterTransactor{contract: contract}, nil
}

// bindTestAlastriaCounter binds a generic wrapper to an already deployed contract.
func bindTestAlastriaCounter(address common.Address, caller bind.ContractCaller, transactor bind.ContractTransactor) (*bind.BoundContract, error) {
	parsed, err := abi.JSON(strings.NewReader(TestAlastriaCounterABI))
	if err != nil {
		return nil, err
	}
	return bind.NewBoundContract(address, parsed, caller, transactor), nil
}

// Call invokes the (constant) contract method with params as input values and
// sets the output to result. The result type might be a single field for simple
// returns, a slice of interfaces for anonymous returns and a struct for named
// returns.
func (_TestAlastriaCounter *TestAlastriaCounterRaw) Call(opts *bind.CallOpts, result interface{}, method string, params ...interface{}) error {
	return _TestAlastriaCounter.Contract.TestAlastriaCounterCaller.contract.Call(opts, result, method, params...)
}

// Transfer initiates a plain transaction to move funds to the contract, calling
// its default method if one is available.
func (_TestAlastriaCounter *TestAlastriaCounterRaw) Transfer(opts *bind.TransactOpts) (*types.Transaction, error) {
	return _TestAlastriaCounter.Contract.TestAlastriaCounterTransactor.contract.Transfer(opts)
}

// Transact invokes the (paid) contract method with params as input values.
func (_TestAlastriaCounter *TestAlastriaCounterRaw) Transact(opts *bind.TransactOpts, method string, params ...interface{}) (*types.Transaction, error) {
	return _TestAlastriaCounter.Contract.TestAlastriaCounterTransactor.contract.Transact(opts, method, params...)
}

// Call invokes the (constant) contract method with params as input values and
// sets the output to result. The result type might be a single field for simple
// returns, a slice of interfaces for anonymous returns and a struct for named
// returns.
func (_TestAlastriaCounter *TestAlastriaCounterCallerRaw) Call(opts *bind.CallOpts, result interface{}, method string, params ...interface{}) error {
	return _TestAlastriaCounter.Contract.contract.Call(opts, result, method, params...)
}

// Transfer initiates a plain transaction to move funds to the contract, calling
// its default method if one is available.
func (_TestAlastriaCounter *TestAlastriaCounterTransactorRaw) Transfer(opts *bind.TransactOpts) (*types.Transaction, error) {
	return _TestAlastriaCounter.Contract.contract.Transfer(opts)
}

// Transact invokes the (paid) contract method with params as input values.
func (_TestAlastriaCounter *TestAlastriaCounterTransactorRaw) Transact(opts *bind.TransactOpts, method string, params ...interface{}) (*types.Transaction, error) {
	return _TestAlastriaCounter.Contract.contract.Transact(opts, method, params...)
}

// Get is a free data retrieval call binding the contract method 0x6d4ce63c.
//
// Solidity: function get() constant returns(retVal uint256)
func (_TestAlastriaCounter *TestAlastriaCounterCaller) Get(opts *bind.CallOpts) (*big.Int, error) {
	var (
		ret0 = new(*big.Int)
	)
	out := ret0
	err := _TestAlastriaCounter.contract.Call(opts, out, "get")
	return *ret0, err
}

// Get is a free data retrieval call binding the contract method 0x6d4ce63c.
//
// Solidity: function get() constant returns(retVal uint256)
func (_TestAlastriaCounter *TestAlastriaCounterSession) Get() (*big.Int, error) {
	return _TestAlastriaCounter.Contract.Get(&_TestAlastriaCounter.CallOpts)
}

// Get is a free data retrieval call binding the contract method 0x6d4ce63c.
//
// Solidity: function get() constant returns(retVal uint256)
func (_TestAlastriaCounter *TestAlastriaCounterCallerSession) Get() (*big.Int, error) {
	return _TestAlastriaCounter.Contract.Get(&_TestAlastriaCounter.CallOpts)
}

// Value is a free data retrieval call binding the contract method 0x3fa4f245.
//
// Solidity: function value() constant returns(uint256)
func (_TestAlastriaCounter *TestAlastriaCounterCaller) Value(opts *bind.CallOpts) (*big.Int, error) {
	var (
		ret0 = new(*big.Int)
	)
	out := ret0
	err := _TestAlastriaCounter.contract.Call(opts, out, "value")
	return *ret0, err
}

// Value is a free data retrieval call binding the contract method 0x3fa4f245.
//
// Solidity: function value() constant returns(uint256)
func (_TestAlastriaCounter *TestAlastriaCounterSession) Value() (*big.Int, error) {
	return _TestAlastriaCounter.Contract.Value(&_TestAlastriaCounter.CallOpts)
}

// Value is a free data retrieval call binding the contract method 0x3fa4f245.
//
// Solidity: function value() constant returns(uint256)
func (_TestAlastriaCounter *TestAlastriaCounterCallerSession) Value() (*big.Int, error) {
	return _TestAlastriaCounter.Contract.Value(&_TestAlastriaCounter.CallOpts)
}

// Add is a paid mutator transaction binding the contract method 0x4f2be91f.
//
// Solidity: function add() returns()
func (_TestAlastriaCounter *TestAlastriaCounterTransactor) Add(opts *bind.TransactOpts) (*types.Transaction, error) {
	return _TestAlastriaCounter.contract.Transact(opts, "add")
}

// Add is a paid mutator transaction binding the contract method 0x4f2be91f.
//
// Solidity: function add() returns()
func (_TestAlastriaCounter *TestAlastriaCounterSession) Add() (*types.Transaction, error) {
	return _TestAlastriaCounter.Contract.Add(&_TestAlastriaCounter.TransactOpts)
}

// Add is a paid mutator transaction binding the contract method 0x4f2be91f.
//
// Solidity: function add() returns()
func (_TestAlastriaCounter *TestAlastriaCounterTransactorSession) Add() (*types.Transaction, error) {
	return _TestAlastriaCounter.Contract.Add(&_TestAlastriaCounter.TransactOpts)
}

// Subtract is a paid mutator transaction binding the contract method 0x6deebae3.
//
// Solidity: function subtract() returns()
func (_TestAlastriaCounter *TestAlastriaCounterTransactor) Subtract(opts *bind.TransactOpts) (*types.Transaction, error) {
	return _TestAlastriaCounter.contract.Transact(opts, "subtract")
}

// Subtract is a paid mutator transaction binding the contract method 0x6deebae3.
//
// Solidity: function subtract() returns()
func (_TestAlastriaCounter *TestAlastriaCounterSession) Subtract() (*types.Transaction, error) {
	return _TestAlastriaCounter.Contract.Subtract(&_TestAlastriaCounter.TransactOpts)
}

// Subtract is a paid mutator transaction binding the contract method 0x6deebae3.
//
// Solidity: function subtract() returns()
func (_TestAlastriaCounter *TestAlastriaCounterTransactorSession) Subtract() (*types.Transaction, error) {
	return _TestAlastriaCounter.Contract.Subtract(&_TestAlastriaCounter.TransactOpts)
}
