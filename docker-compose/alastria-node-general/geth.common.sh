# 

NETID="8338"

ISTANBUL_REQUESTTIMEOUT="10000"

SYNCMODE="fast"

CACHE="4196"

GCMODE="full"

TARGETGASLIMIT="8000000"

VERBOSITY="3"

VMODULE="consensus/istanbul/core/core.go=5"

################################################
# CONSIDER EDITING FROM HERE
################################################

# Geth arguments
GLOBAL_ARGS="--networkid $NETID \
--identity $NODE_NAME \
--permissioned \
--cache $CACHE \
--port $NODE_PORT \
--istanbul.requesttimeout $ISTANBUL_REQUESTTIMEOUT \
--verbosity $VERBOSITY \
--emitcheckpoints \
--targetgaslimit $TARGETGASLIMIT \
--syncmode $SYNCMODE \
--gcmode $GCMODE \
--vmodule $VMODULE \
--nousb "

# Any additional arguments
LOCAL_ARGS=""
