# Tests unitarios de WarrantTypes

## Procedimiento

Se puede probar tanto con el nodo general1, como con el general2 utilizando `--network general1` o `--network general2`.

### Compilar, migrar y ejecutar los test

```
$ truffle compile
$ truffle migrate --network general1
$ truffle test --network general1
```

Los modificaciones compile y migrate, sólo se utilizarán si cambia el contrato de partida.