package main

import (
	"net/http"
	_ "net/http/pprof"
	"os"

	"github.com/cosmos/cosmos-sdk/server"
	svrcmd "github.com/cosmos/cosmos-sdk/server/cmd"
	sdk "github.com/cosmos/cosmos-sdk/types"

	"github.com/tharsis/evmos/app"
	cmdcfg "github.com/tharsis/evmos/cmd/config"
)

func main() {
	// The HTTP callable pprof hook as per https://pkg.go.dev/net/http/pprof.
	go func() {
		if err := http.ListenAndServe(":6060", nil); err != nil {
			panic(err)
		}
	}()

	setupConfig()
	cmdcfg.RegisterDenoms()

	rootCmd, _ := NewRootCmd()

	if err := svrcmd.Execute(rootCmd, app.DefaultNodeHome); err != nil {
		switch e := err.(type) {
		case server.ErrorCode:
			os.Exit(e.Code)

		default:
			os.Exit(1)
		}
	}
}

func setupConfig() {
	// set the address prefixes
	config := sdk.GetConfig()
	cmdcfg.SetBech32Prefixes(config)
	if err := cmdcfg.EnableObservability(); err != nil {
		panic(err)
	}
	cmdcfg.SetBip44CoinType(config)
	config.Seal()
}
