# Entorno de testing de Alastria

Este entorno, permite levantar 3 nodos Quorum R2.0.0, uno de ellos validador y dos regulares.

Además de esto, se suministra un cakeshop y un projecto truffle, ambos configurados contra uno de los nodos regulares.

## Bootstraping

Para probar este entorno, necesitas Ubuntu Linux 16.04 o Centos 7 utilizando el [bootstrap.sh](https://github.com/alastria/alastria-node/blob/feature/ibft/scripts/bootstrap.sh) del proyecto alastria/alastria-node.

## Puesta en marcha del entorno

Independientemente de donde se realize la descarga del repositorio, el entorno está pensado para ejecutarse desde `$HOME/alastria`, por lo que, lo más sencillo es realizar un enlace simbólico estándo en la carpeta threenodes:

```
$ ln -s alastria $HOME/alastria
```

Utilize eth-netstats como panel de control de la red utilizando:

```
$ bin/start_ethstats.sh
```

Para arrancar los 3 nodos quorum:

```
$ bin/start_test.sh validator
$ bin/start_test.sh general1
$ bin/start_test.sh general2
```

Con estas tres instrucciones, se inicializan los 3 nodos. En la carpeta `logs/` se habrán creado 5 ficheros de log, 3 quroum y 2 constellation.

Ahora, si queremos disponer de un explorador de bloques y entorno de desarrollo de smart contract, podemos levantar cakeshop:

```
$ bin/start_cakeshop.sh
```

**NOTA**: Por razones de tamaño del fichero debe descargarse de [aquí](https://github.com/alastria/cakeshop/releases/download/v0.10.0-alastria/cakeshop.war) a la carpeta `alastria/cakeshop`

Por último, para testear que la red despliega contratos, se puede utilizar el projecto [truffle](truffle/README.md).