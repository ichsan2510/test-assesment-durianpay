# Fetch the existing VPC
data "aws_vpc" "existing_vpc" {
  filter {
    name   = "tag:Name"
    values = ["main-vpc"] 
  }
}

# Fetch an existing private subnet
data "aws_subnet" "private_subnet" {
  filter {
    name   = "tag:Name"
    values = ["private-subnet"] 
  }

  vpc_id = data.aws_vpc.existing_vpc.id
}