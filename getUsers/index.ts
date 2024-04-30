import { CognitoIdentityProvider } from "@aws-sdk/client-cognito-identity-provider"

export const handler = async (event) => {
    const cognitoIdentityProvider = new CognitoIdentityProvider({
      region: "us-east-1",
    })
    const clienteID = process.env.clienteID
    const { userType } = JSON.parse(event.body)
    const params = {
        UserPoolId: clienteID,
        AttributesToGet: ['custom:cpf'],
        Filter: `custom:userType = ${userType}`
    };

    try {
        const data = await cognitoIdentityProvider.listUsers(params).promise();
        return {
            statusCode: 200,
            body: JSON.stringify(data.Users),
        };
    } catch (err) {
        return {
            statusCode: 500,
            body: JSON.stringify(err.message),
        };
    }
};