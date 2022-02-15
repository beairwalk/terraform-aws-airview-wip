const { Authenticator } = require('cognito-at-edge');
const authenticator = new Authenticator({
  region: 'eu-west-2', 
  userPoolId: '${poolId}',
  userPoolAppId: '${appId}', 
  userPoolDomain: '${poolDomain}' 
});
exports.handler = async (request) => authenticator.handle(request);