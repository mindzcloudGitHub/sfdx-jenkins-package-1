export CLIENT_ID="3MVG9n_HvETGhr3CIZVAQdHYTNhPvX.DFYU.AAauOXrt9ZuJBGAW4I0GZnh.OJNxeC.7Pr4sul6h6W0Gf9Aid"

  export CI_USERNAME="cicd@mindzcloud.com"

  export INSTANCE_URL="https://login.salesforce.com"

  export JWT_KEY_FILE="99b23b4a-15fc-45a4-bd94-951bad63468b"
  export WORKSPACE_DIR='pwd'
  export PATH_TO_SOURCE="$WORKSPACE_DIR"


npm install sfdx-cli  //@7.119.3
echo "Installed SFDC CLI Version:"
$WORKSPACE_DIR/node_modules/bin/sfdx -version


$WORKSPACE_DIR/node_modules/bin/sfdx force:auth:jwt:grant --clientid $CLIENT_ID \
--jwtkeyfile $JWT_KEY_FILE --username $CI_USERNAME \
--instanceurl $INSTANCE_URL


export METADATA_API_DIR="mdapi_output_dir"
cd $PATH_TO_SOURCE
echo "Current dir:" 'pwd'
$WORKSPACE_DIR/node_modules/bin/sfdx force:source:convert -d $METADATA_API_DIR
echo "Metadata directory generated contents:"
ls -lR $METADATA_API_DIR
echo "done"



export WAIT_TIME_MINS=60

SFDX_DISABLE_INSIGHTS=true \
$WORKSPACE_DIR/node_modules/bin/sfdx force:mdapi:deploy --deploydir $METADATA_API_DIR \
--targetusername $CI_USERNAME \
--wait $WAIT_TIME_MINS \
--soapdeploy

