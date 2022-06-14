const { Authenticator } = require('cognito-at-edge');
const authenticator = new Authenticator({
  region: 'eu-west-2', 
  userPoolId: 'eu-west-2_y8SmqAfJV',
  userPoolAppId: '26a27ltsrrmgtrvrp3itu320nt', 
  userPoolDomain: 'airviewtest.auth.us-east-1.amazoncognito.com' 
});
exports.handler = async (request) => authenticator.handle(request);