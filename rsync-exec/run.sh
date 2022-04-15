#!/bin/bash
CF_APP=$(yq '.applications[0].name' /app/manifest.yaml)
appid=$(cf app $CF_APP --guid)

if [ $appid == *"not found"* ] || [ "$CF_PUSH_INIT" == "true" ]; then
    echo ======== Pushing app ======
    cd /app
    cf push $CF_APP -p /syncorig
    cd .. 
else
    echo ====== Existing app $CF_APP is found. Using livesync instead of cf push. You can override this behavior by adding CF_PUSH_INIT=true into .env file =====
    /resync.sh
fi
exec /bin/bash -c "trap : TERM INT; sleep infinity & wait"