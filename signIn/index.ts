import { CognitoIdentityProvider } from "@aws-sdk/client-cognito-identity-provider"

export const handler = async (event) => {
  const cognitoIdentityProvider = new CognitoIdentityProvider({
    region: "us-east-1",
  })
  const { username, password } = JSON.parse(event.body)
  const clienteID = process.env.clienteID

  const params = {
    AuthFlow: "USER_PASSWORD_AUTH",
    ClientId: clienteID,
    AuthParameters: {
      USERNAME: username,
      PASSWORD: password,
      SECRET_KEY: "true",
    },
  }

  try {
    const data = await cognitoIdentityProvider.initiateAuth(params)
    return { statusCode: 200, body: JSON.stringify(data) }
  } catch (error) {
    console.error("Error registering user:", error)
    return { statusCode: 500, body: JSON.stringify({ error: error.message }) }
  }
}

/**
 * payload signup
 * 
 * {
    "username": "usuario",
    "password": "senha",
  }
 */
