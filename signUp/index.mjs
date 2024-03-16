import { CognitoIdentityProvider } from "@aws-sdk/client-cognito-identity-provider";
import * as http from 'http';

export const handler = async (event) => {
  const cognitoIdentityProvider = new CognitoIdentityProvider({ region: 'us-east-1' });
  const { username, password, name, email } = JSON.parse(event.body);
  const clienteID = process.env.clienteID;
  const apiUrl = process.env.API_URL;

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
      }
    ]
  };

  const postData = JSON.stringify({
    name,
    email,
    "cpf": username,
    usuario: {
      "login": username,
      "senha": password,
    }
  })

  const requestOptions = {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
    }
  };

  const handleResponse = (res) => {
    let data = '';

    res.on('data', (chunk) => {
      data += chunk;
    });

    res.on('end', () => {
      resolve(data);
    });
  };

  try {
    // await cognitoIdentityProvider.signUp(params);

    const request = await new Promise((resolve, reject) => {
      const req = http.request(apiUrl, requestOptions, handleResponse)

      req.on('error', (error) => {
        reject(error);
      });

      req.write(postData);
      req.end();
    });

    return { statusCode: 200, body: JSON.stringify({ "dataSuccess": request }) };
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