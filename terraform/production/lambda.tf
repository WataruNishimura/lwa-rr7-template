module "lambda" {
  source = "../modules/lambda"

  function_name = "lwa-rr7-production"
  ecr_repository_name = "example/app"
}
