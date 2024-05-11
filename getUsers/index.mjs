import { CognitoIdentityProvider } from "@aws-sdk/client-cognito-identity-provider"

function filterUsersByAttribute(users, attributeName, attributeValue) {
    return users.filter(user => {
        const attribute = user.Attributes.find(attr => attr.Name === attributeName);
        return attribute && attribute.Value === attributeValue;
    });
}

export const handler = async (event) => {
    const cognitoIdentityProvider = new CognitoIdentityProvider({
      region: "us-east-1",
    })
    const clienteID = process.env.userPoolID
    const { userType } = JSON.parse(event.body)
    const params = {
        UserPoolId: clienteID,
        AttributesToGet: ['custom:tipoAcesso'],
        // Filter: `custom:tipoAcesso = \"${userType}\"`
    };
    

    try {
        const data = await cognitoIdentityProvider.listUsers(params);
        const filteredUsers = filterUsersByAttribute(data.Users, "custom:tipoAcesso", userType);
        return {
            statusCode: 200,
            body: JSON.stringify(filteredUsers),
        };
    } catch (err) {
        return {
            statusCode: 500,
            body: JSON.stringify(err.message),
        };
    }
};