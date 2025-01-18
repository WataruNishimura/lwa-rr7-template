resource "aws_ecr_repository" "app_repo" {
  name = var.ecr_repository_name
}

resource "aws_lambda_function" "this" {
  function_name = var.function_name
  package_type  = "Image"
  image_uri     = "${aws_ecr_repository.app_repo.repository_url}:latest"
  role          = aws_iam_role.lambda_role.arn
  timeout       = 15
  architectures = ["arm64"]

  environment {
    variables = {
      AWS_LAMBDA_EXEC_WRAPPER    = "/opt/bootstrap"
      AWS_LWA_ENABLE_COMPRESSION = true
      PORT                       = 3000
      RUST_LOG                   = "info"
    }
  }
}

resource "aws_lambda_function_url" "latest" {
  function_name      = aws_lambda_function.this.function_name
  authorization_type = "NONE"
}

resource "aws_iam_role" "lambda_role" {
  name = "lambda_exec_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_basic" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
