PROJECT=PANHENIO
PROJECT_LOWER=panhenio
ENVIRONMENT=PROD
ENVIRONMENT_LOWER=prod
DOMAIN_NAME=panhenio.pl

infra-cicd-deploy:
	aws cloudformation deploy --stack-name "${PROJECT}-CICD-${ENVIRONMENT}" \
		--template-file cicd.yaml \
		--parameter-overrides Project=${PROJECT} ProjectLower=${PROJECT_LOWER} Environment=${ENVIRONMENT} EnvironmentLower=${ENVIRONMENT_LOWER} DomainName=${DOMAIN_NAME}

infra-data-deploy:
	aws cloudformation deploy --stack-name "${PROJECT}-DATA-${ENVIRONMENT}" \
		--template-file data.yaml \
		--parameter-overrides Project=${PROJECT} ProjectLower=${PROJECT_LOWER} Environment=${ENVIRONMENT}

infra-website-deploy:
	aws cloudformation deploy --stack-name "${PROJECT}-WEBSITE-${ENVIRONMENT}" \
		--template-file website.yaml \
		--parameter-overrides Project=${PROJECT} ProjectLower=${PROJECT_LOWER} Environment=${ENVIRONMENT} EnvironmentLower=${ENVIRONMENT_LOWER}

infra-gateway-deploy:
	aws cloudformation deploy --stack-name "${PROJECT}-GATEWAY-${ENVIRONMENT}" \
		--template-file gateway.yaml \
		--parameter-overrides Project=${PROJECT} ProjectLower=${PROJECT_LOWER} Environment=${ENVIRONMENT} EnvironmentLower=${ENVIRONMENT_LOWER} DomainName=${DOMAIN_NAME}
