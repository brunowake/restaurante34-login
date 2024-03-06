import { CognitoIdentityProvider } from "@aws-sdk/client-cognito-identity-provider";

export const handler = async (event) => {
    const cognitoIdentityProvider = new CognitoIdentityProvider({ region: 'us-east-1' });
    const { username, password, name, email, cpf } = JSON.parse(event.body);
    const clienteID = process.env.clienteID;

    const params = {
        ClientId: clienteID,
        Username: username,
        Password: password,
        UserAttributes: [
            {
                Name: 'name',
                Value: name
            },
            {
                Name: 'email',
                Value: email
            },
            {
                Name: 'custom:cpf',
                Value: cpf
            }
        ]
    };
    
    try {
        const data = await cognitoIdentityProvider.signUp(params);
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
    "username": "usuario",
    "password": "senha",
    "name": "Nome Teste",
    "email": "email@gmail.com",
    "cpf": "11111111111"
  }
 */