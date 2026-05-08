PROJECT=PANHENIO
PROJECT_LOWER=panhenio
ENVIRONMENT=PROD
ENVIRONMENT_LOWER=prod
DOMAIN_NAME=panhenio.pl

cicd-deploy:
	aws cloudformation deploy --stack-name "${PROJECT}-CICD-${ENVIRONMENT}" \
		--template-file cicd.yaml \
		--parameter-overrides Project=${PROJECT} ProjectLower=${PROJECT_LOWER} Environment=${ENVIRONMENT} EnvironmentLower=${ENVIRONMENT_LOWER} DomainName=${DOMAIN_NAME}

data-deploy:
	aws cloudformation deploy --stack-name "${PROJECT}-DATA-${ENVIRONMENT}" \
		--template-file data.yaml \
		--parameter-overrides Project=${PROJECT} ProjectLower=${PROJECT_LOWER} Environment=${ENVIRONMENT}

email-deploy:
	aws cloudformation deploy --stack-name "${PROJECT}-EMAIL-${ENVIRONMENT}" \
		--template-file email.yaml \
		--parameter-overrides Project=${PROJECT} Environment=${ENVIRONMENT}

website-deploy:
	aws cloudformation deploy --stack-name "${PROJECT}-WEBSITE-${ENVIRONMENT}" \
		--template-file website.yaml \
		--parameter-overrides Project=${PROJECT} ProjectLower=${PROJECT_LOWER} Environment=${ENVIRONMENT} EnvironmentLower=${ENVIRONMENT_LOWER}

waf-deploy:
	aws cloudformation deploy --stack-name "${PROJECT}-WAF-${ENVIRONMENT}" \
		--template-file waf.yaml \
		--region us-east-1 \
		--parameter-overrides Project=${PROJECT} Environment=${ENVIRONMENT}

gateway-deploy:
	$(eval WAF_ARN := $(shell aws cloudformation describe-stacks --stack-name "${PROJECT}-WAF-${ENVIRONMENT}" --region us-east-1 --query "Stacks[0].Outputs[?OutputKey=='WebAclArn'].OutputValue" --output text))
	aws cloudformation deploy --stack-name "${PROJECT}-GATEWAY-${ENVIRONMENT}" \
		--template-file gateway.yaml \
		--parameter-overrides Project=${PROJECT} ProjectLower=${PROJECT_LOWER} Environment=${ENVIRONMENT} EnvironmentLower=${ENVIRONMENT_LOWER} DomainName=${DOMAIN_NAME} WafWebAclArn=${WAF_ARN}

deploy: cicd-deploy data-deploy email-deploy waf-deploy website-deploy gateway-deploy