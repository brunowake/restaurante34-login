import { CognitoIdentityProvider } from "@aws-sdk/client-cognito-identity-provider";

export const handler = async (event) => {
    const cognitoIdentityProvider = new CognitoIdentityProvider({ region: 'us-east-1' });
    const { username, confirmationCode} = JSON.parse(event.body);
    const clienteID = process.env.clienteID;

    const params = {
        ClientId: clienteID,
        Username: username,
        ConfirmationCode:confirmationCode
    };
    
    try {
        const data = await cognitoIdentityProvider.confirmSignUp(params);
        return { statusCode: 200, body: JSON.stringify(data) };
    } catch (error) {
        console.error('Error registering user:', error);
        return { statusCode: 500, body: JSON.stringify({ error: error.message }) };
    }
    
};
/**
 * payload signup
 * 
 * {
    "username": "teste",
    "confirmationCode": "102030"
  }
 */