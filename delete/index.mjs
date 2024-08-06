import { CognitoIdentityProvider } from "@aws-sdk/client-cognito-identity-provider";

export const handler = async (event) => {
  const cognitoIdentityProvider = new CognitoIdentityProvider({
    region: "us-east-1",
  });

  const { username } = JSON.parse(event.body);
  const clienteID = process.env.userPoolID

  const params = {
    UserPoolId: clienteID,
    Username: username,
  };

  try {
    await cognitoIdentityProvider.adminDeleteUser(params);
    return { statusCode: 200, body: JSON.stringify({ message: `User ${username} deleted successfully.` }) };
  } catch (error) {
    console.error("Error deleting user:", error);
    return { statusCode: 500, body: JSON.stringify({ error: error.message }) };
  }
};