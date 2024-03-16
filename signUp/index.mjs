import { CognitoIdentityProvider } from "@aws-sdk/client-cognito-identity-provider";

export const handler = async (event) => {
  const cognitoIdentityProvider = new CognitoIdentityProvider({ region: 'us-east-1' });
  const { username, password, name, email } = JSON.parse(event.body);
  const clienteID = process.env.clienteID;
  const apiUrl = process.env.apiUrl;

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
    "nome": name,
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
    },
    body: postData,
  };


  try {
    await cognitoIdentityProvider.signUp(params);

    const response = await fetch(apiUrl, requestOptions);

    if (!response.ok) {
      throw new Error('Network response was not ok');
    }

    return { statusCode: 200, body: JSON.stringify({ "dataSuccess": "criado com sucesso" }) };
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