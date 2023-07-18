# NOTE: This is verbose on purpose.
################################################################################
## Initial Set Up & Clean Up of Past Runs
################################################################################

set -e

if [ $# -gt 3 ]
then
    echo "usage: $0 results_dir golds_dir"
    exit
fi

REMOTESYNCRESULTS=$1
GOLDOUTPUT=$2
NDF=$3

DEBUGLEVEL=${DEBUGLEVEL-1}

CLIENTOUT=$REMOTESYNCRESULTS/clients
CLIENTCLEAN=$REMOTESYNCRESULTS/clients-cleaned

mkdir -p $CLIENTOUT
mkdir -p $CLIENTCLEAN

CLIENTOPTS="--password hello --ndf $NDF --verify-sends --sendDelay 100 --waitTimeout 360 -v $DEBUGLEVEL"

#export GRPC_GO_LOG_VERBOSITY_LEVEL=99
#export GRPC_GO_LOG_SEVERITY_LEVEL=info

###############################################################################
# New Test Goes Here
###############################################################################

echo "TESTING REMOTE SYNCHRONISATION..."


CLIENTCMD="timeout 240s bin/client remoteSync $CLIENTOPTS -l $CLIENTOUT/client700.log -s blobs/700 --remoteUsername waldo --remotePassword hunter2 --remoteSyncServerAddress 0.0.0.0:22841 --remoteCertPath keys/remoteSyncServer.crt"
eval $CLIENTCMD >> $CLIENTOUT/client700.txt &
PIDVAL1=$!
echo "$CLIENTCMD -- $PIDVAL1"
wait $PIDVAL1


echo "TESTS EXITED SUCCESSFULLY, CHECKING OUTPUT..."

cp $CLIENTOUT/*.txt $CLIENTCLEAN/

sed -i.bak 's/Sending\ to\ .*\:/Sent:/g' $CLIENTCLEAN/client*.txt
sed -i.bak 's/Message\ from\ .*, .* Received:/Received:/g' $CLIENTCLEAN/client*.txt
sed -i.bak 's/ERROR.*Signature/Signature/g' $CLIENTCLEAN/client*.txt
sed -i.bak 's/[Aa]uthenticat.*$//g' $CLIENTCLEAN/client*.txt
rm $CLIENTCLEAN/client*.txt.bak

for C in $(ls -1 $CLIENTCLEAN | grep -v client11[01]); do
    sort -o tmp $CLIENTCLEAN/$C  || true
    cp tmp $CLIENTCLEAN/$C
    # uniq tmp $CLIENTCLEAN/$C || true
done

set -e

set +x
diff -aru $GOLDOUTPUT $CLIENTCLEAN

echo "NO OUTPUT ERRORS, SUCCESS!"
