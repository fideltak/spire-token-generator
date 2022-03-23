#!/bin/sh
if [ -z "$SPIRE_POD_LABEL" ]; then
  echo "Please specify pod label of Spire Server as SPIRE_POD_LABEL"
  exit 1
fi

if [ -z "$SPIRE_SPIFFE_ID" ]; then
  echo "Please specify SPIFFE ID as SPIRE_SPIFFE_ID like spiffe://swarm.learning/swarm/sn-agent"
  exit 1
fi

if [ -z "$SPIRE_TOKEN_SECRET_NAME" ]; then
  echo "Please specify secret name to save token"
  exit 1
fi

if [ -z "$SPIRE_TOKEN_DIR_PATH" ]; then
  SPIRE_TOKEN_DIR_PATH="/tmp/spire"
fi
echo "SPIRE_POD_LABEL: $SPIRE_POD_LABEL"
echo "SPIRE_SPIFFE_ID: $SPIRE_SPIFFE_ID"
echo "SPIRE_TOKEN_SECRET_NAME: $SPIRE_TOKEN_SECRET_NAME"

SPIRE_POD_NAME=`kubectl get po -l $SPIRE_POD_LABEL -o jsonpath='{.items[0].metadata.name}'`
echo "SPIRE_POD_NAME: $SPIRE_POD_NAME"
echo "kubectl exec $SPIRE_POD_NAME -- /spire/bin/spire-server token generate -spiffeID $SPIRE_SPIFFE_ID"

SPIRE_TOKEN=`kubectl exec $SPIRE_POD_NAME -- /spire/bin/spire-server token generate -spiffeID $SPIRE_SPIFFE_ID`
echo "Response From SPIRE Server... $SPIRE_TOKEN"
SPIRE_TOKEN=`echo $SPIRE_TOKEN| sed 's/Token: //g'`
echo "Token has been formatted... $SPIRE_TOKEN"

if [ -z "$SPIRE_TOKEN" ]; then
  echo "Could not get token from Spire Server"
  exit 1
fi

if [ ! -d $SPIRE_TOKEN_DIR_PATH ]; then
  echo "Create directory to save token"
  mkdir -p $SPIRE_TOKEN_DIR_PATH
fi
SPIRE_TOKEN_FILE_PATH=`echo $SPIRE_TOKEN_DIR_PATH/token`
echo $SPIRE_TOKEN > $SPIRE_TOKEN_FILE_PATH

echo "Update secret"
kubectl get secret $SPIRE_TOKEN_SECRET_NAME -o json | jq --arg token "$(echo -n $SPIRE_TOKEN | base64)"  '.data["token"]=$token'| kubectl apply -f -
if [ $? -ne 0 ]; then
  echo "Failed to save token as secret"
  exit 1
fi

if [ -e $SPIRE_TOKEN_FILE_PATH ]; then
  echo "TOKEN is $SPIRE_TOKEN"
  echo "Succeed!"
  exit 0
fi
  echo "FAILED!"
exit 1