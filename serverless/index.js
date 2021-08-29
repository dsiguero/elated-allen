const AWSXRay = require('aws-xray-sdk-core');
const AWS = AWSXRay.captureAWS(require('aws-sdk'));

// Create s3 client outside of lambda to be able to reuse it
const s3 = new AWS.S3();
const dynamoDB = new AWS.DynamoDB();

exports.handler = async function(event, context) {
    // Get file path from bucket name and file key
    const bucketName = event.Records[0].s3.bucket.name;
    const fileKey = event.Records[0].s3.object.key;

    const fileContents = await getFileContentsFromBucket(bucketName, fileKey);

    return await insertIntoDynamoTable(fileKey, fileContents);
}

async function getFileContentsFromBucket(bucketName, fileKey) {
    const content = await s3.getObject({
        Bucket: bucketName,
        Key: fileKey,
    }).promise();

    return content.Body.toString('ascii');
}

async function insertIntoDynamoTable(fileKey, fileContent) {
    await dynamoDB.putItem({
        TableName: process.env.DYNAMODB_TABLE_DESTINATION,
        Item: {
            file_key: {
                S:  fileKey,
            },
            content: {
                S: fileContent,
            },
        },
    }).promise();
}