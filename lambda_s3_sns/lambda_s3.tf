/*resource "aws_iam_role" "s3_lamdba_sns" {
  name = "s3_lambda_sns"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com",
        }
      },
    ]
  })
} */

data "aws_iam_policy_document" "resource_based" {
    statement {
      effect = "Allow"
      
      principals {
        type = "Service"
        identifiers = ["sns.amazonaws.com", "s3.amazonaws.com", "lambda.amazonaws.com"]
      }
      actions = ["sts:AssumeRole"]
    }
  } 

resource "aws_iam_role" "lambds_sns_role" {
  name = "lambda_sns_role"
  assume_role_policy = data.aws_iam_policy_document.resource_based.json
}

data "aws_iam_policy_document" "Identity_based_lambda" {
  statement {
    effect = "Allow"
    actions = ["lambda:*", "sns:*"]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "policy" {
  name = "lambda_sns_policy"
  description = "A test policy"
  policy = data.aws_iam_policy_document.Identity_based_lambda.json
}

resource "aws_iam_role_policy_attachment" "test-attach" {
  role = aws_iam_role.lambds_sns_role.name
  policy_arn = aws_iam_policy.policy.arn
}

resource "aws_s3_bucket" "sample" {
  bucket = "bucket-sample-rsk2"
}

resource "aws_s3_object" "name" {
  bucket = aws_s3_bucket.sample.bucket
  key = "example.txt"
  source = "./example.txt"
  etag = filemd5("./example.txt")
}

data "archive_file" "lambda" {
  type = "zip"
  source_dir = "s3-lambda-function"
  output_path = "s3-lambda-function.zip"
}

resource "aws_lambda_function" "s3-lambda-function" {
  filename = "s3-lambda-function.zip"
  function_name = "s3-lambda-function"
  role = aws_iam_role.lambds_sns_role.arn
  handler = "s3-lambda-function/s3-lambda-function.lambda_handler"
  
  source_code_hash = data.archive_file.lambda.output_base64sha256
  runtime = "python3.11"
  memory_size = 128
  timeout = 30

}

resource "aws_lambda_permission" "s3-lambda" {
  statement_id = "s3-lambda-sns"
  action = "lambda:InvokeFunction"
  function_name = aws_lambda_function.s3-lambda-function.function_name
  principal = "s3.amazonaws.com"
  source_arn = "arn:aws:s3:::bucket-sample-rsk2"
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.sample.id
  lambda_function {
    lambda_function_arn = aws_lambda_function.s3-lambda-function.arn
    events = ["s3:ObjectCreated:*"]
  }
}

resource "aws_sns_topic" "sns-topic" {
  name = "s3-lambda-sns"  
}

resource "aws_sns_topic_subscription" "subscription" {
  topic_arn = aws_sns_topic.sns-topic.arn
  protocol = "email"
  endpoint = "saikishoreredd789@gmail.com"
}


  


