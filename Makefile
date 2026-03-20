PROJECT=PANHENIO
PROJECT_LOWER=panhenio
ENVIRONMENT=PROD
ENVIRONMENT_LOWER=prod

infra-website-deploy:
	aws cloudformation deploy --stack-name "${PROJECT}-WEBSITE-${ENVIRONMENT}" \
		--template-file website.yaml \
		--parameter-overrides Project=${PROJECT} ProjectLower=${PROJECT_LOWER} Environment=${ENVIRONMENT} EnvironmentLower=${ENVIRONMENT_LOWER}

infra-gateway-deploy:
	aws cloudformation deploy --stack-name "${PROJECT}-GATEWAY-${ENVIRONMENT}" \
		--template-file gateway.yaml \
		--parameter-overrides Project=${PROJECT} ProjectLower=${PROJECT_LOWER} Environment=${ENVIRONMENT} EnvironmentLower=${ENVIRONMENT_LOWER}
