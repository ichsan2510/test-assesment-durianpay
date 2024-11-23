remote_state {
  backend = "s3"
  config = {
    bucket         = "global-terraform-state"
    key            = "${path_relative_to_include()}"
    region         = "ap-southeast-3"
    encrypt        = true
    dynamodb_table = "my-lock-table"
  }
}