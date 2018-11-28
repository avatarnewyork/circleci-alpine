[ -z $PHP_TAG ] && export PHP_VERSION=php-7.1 || export PHP_VERSION=$PHP_TAG
export TESTINGVAR=testing
if [ -z $CIRCLE_BRANCH ]; then
    export BRANCH=prod-$CIRCLE_TAG
    export INFRASTRUCTURE=prod
    export AWS_DEFAULT_REGION=$DEPLOY_PROD_REGION
    export DEPLOY_ENVIRONMENT=$DEPLOY_PROD_ENVIRONMENT
else
    export BRANCH=$CIRCLE_BRANCH
    export INFRASTRUCTURE=stage
    export AWS_DEFAULT_REGION=$DEPLOY_STAGE_REGION
    export DEPLOY_ENVIRONMENT=$DEPLOY_STAGE_ENVIRONMENT
fi