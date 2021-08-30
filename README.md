# How to deploy

1. Ensure to set the AWS Account ID in the following files:
```
infra/etc/global.tfvars
factorial/update_image.sh
```

2. Bootstrap the tfscaffold infrastructure. This creates the underlying resources where the TF remote state will be
stored. From the `infra` folder, run the following commands.
```
bin/terraform.sh --project elated-allen \
    --region eu-west-1 \
    --bootstrap \
    --action plan

bin/terraform.sh --project elated-allen \
    --region eu-west-1 \
    --bootstrap \ 
    --action apply
```

3. Plan/Apply the `core` component. This component creates the VPC, ECR registry and ECS cluster that will be used later, 
by the factorial service. From the `infra` folder, run the following commands.
```
bin/terraform.sh --project elated-allen \
    --region eu-west-1 \
    --environment develop \
    --component core \
    --action plan

bin/terraform.sh --project elated-allen \
    --region eu-west-1 \
    --environment develop \
    --component core \
    --action apply
```

4. At this point, the `factorial` service docker image can be created, running the `factorial/update_image.sh` script.
This script requires the environment name as a parameter, but will use `develop` by default if no parameter is passed.
The script requires the AWS CLI, `docker` and `jq` (retrieves the version from package.json) to be installed. From the
`factorial` folder, run the following command:
```
./update-image.sh develop
```

5. After specifying the docker image version in `infra/etc/env_eu-west-1_develop.tfvars`, the `factorial` service can be
deployed. From the `infra` folder, run the following commands.
```
bin/terraform.sh --project elated-allen \
    --region eu-west-1 \
    --environment develop \
    --component factorial \
    --action plan

bin/terraform.sh --project elated-allen \
    --region eu-west-1 \
    --environment develop \
    --component factorial \
    --action apply
```

6. Plan/apply the `serverless` component. This component will create an empty Lambda function, which code will be
uploaded in the following step. This is done to separate the provisioning and deployment steps. From the `infra` folder,
run the following commands.
```
bin/terraform.sh --project elated-allen \
    --region eu-west-1 \
    --environment develop \
    --component serverless \
    --action plan

bin/terraform.sh --project elated-allen \
    --region eu-west-1 \
    --environment develop \
    --component serverless \
    --action apply
```

7. Build the lambda function and upload the resulting zip artifact to lambda. From the `serverless` folder run the
`update-function.sh` script, passing the lambda function name as an argument:
```
./update-function.sh elated-allen-develop-serverless-csv-writer
```

8. At this point, all infrastructure and application code has been deployed.