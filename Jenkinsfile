#!groovy

import groovy.json.JsonSlurperClassic

node {

    
// CONFIGURATION:
//
// CLIENT_ID is updated on sandbox refreshed. It must match the connected app in the target ORG
  export CLIENT_ID="3MVG9n_HvETGhr3CIZVAQdHYTNhPvX.DFYU.AAauOXrt9ZuJBGAW4I0GZnh.OJNxeC.7Pr4sul6h6W0Gf9Aid"
//
// CI_USERNAME must match the deployment user for the target ORG and must be associated with a
// profile or permission set which has access to the connected app specified above
  export CI_USERNAME="cicd@mindzcloud.com"
//
// INSTANCE_URL should be login for prod or test for sandbox
  export INSTANCE_URL="https://login.salesforce.com"
//
// JWT_KEY_FILE does not need to be updated on refresh. Same cert can be installed in multiple orgs,
// so this most likely does not need to be updated
  export JWT_KEY_FILE="2e7e39c5-ddf9-4437-bc91-e503b901ad45"
  export WORKSPACE_DIR='pwd'
  export PATH_TO_SOURCE="$WORKSPACE_DIR"

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

echo "-------------------------------------------------------------------------"
echo "Installing SFDC CLI                                                      "
echo "-------------------------------------------------------------------------"

// Supporting documentation:
// https://developer.salesforce.com/docs/atlas.en-us.sfdx_setup.meta/sfdx_setup/sfdx_setup_install_cli.htm//sfdx_setup_install_cli_npm
// NOTE: npm proxy not needed,

npm install sfdx-cli@7.119.3
echo "Installed SFDC CLI Version:"
$WORKSPACE_DIR/node_modules/.bin/sfdx --version
echo "done"

echo "-------------------------------------------------------------------------"
echo "Setup HTTP PROXY                                                         "
echo "-------------------------------------------------------------------------"


echo "-------------------------------------------------------------------------"
echo "Authorizing CI User                                                      "
echo "-------------------------------------------------------------------------"


// Supporting SFDC documentation
//
//   https://developer.salesforce.com/docs/atlas.en-us.sfdx_dev.meta/sfdx_dev/sfdx_dev_auth_jwt_flow.htm

$WORKSPACE_DIR/node_modules/.bin/sfdx force:auth:jwt:grant --clientid $CLIENT_ID \
--jwtkeyfile $JWT_KEY_FILE --username $CI_USERNAME \
--instanceurl $INSTANCE_URL

echo "done"

echo "-------------------------------------------------------------------------"
echo "Convert DX Source to Metadata API format                                 "
echo "-------------------------------------------------------------------------"

// Supporting documentation:
// https://developer.salesforce.com/docs/atlas.en-us.sfdx_dev.meta

export METADATA_API_DIR="mdapi_output_dir"
cd $PATH_TO_SOURCE
echo "Current dir:" `pwd`
$WORKSPACE_DIR/node_modules/.bin/sfdx force:source:convert -d $METADATA_API_DIR
echo "Metadata directory generated contents:"
ls -lR $METADATA_API_DIR
echo "done"


echo "-------------------------------------------------------------------------"
echo "Deploy                                                                   "
echo "-------------------------------------------------------------------------"

// Supporting documentation:
// https://developer.salesforce.com/docs/atlas.en-us.sfdx_dev.meta
//
export WAIT_TIME_MINS=60

SFDX_DISABLE_INSIGHTS=true \
$WORKSPACE_DIR/node_modules/.bin/sfdx force:mdapi:deploy --deploydir $METADATA_API_DIR \
--targetusername $CI_USERNAME \
--wait $WAIT_TIME_MINS \
--soapdeploy
}
