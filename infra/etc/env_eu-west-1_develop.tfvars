# Define variable values to be fed into components in the components directory that will each form a part of the examplenv environment...

environment = "develop"

default_tags = {
  "Project"     = "elated-allen"
  "Environment" = "develop"
}

vpc_cidr = "10.0.0.0/16"

private_subnet_a = "10.0.1.0/24"
private_subnet_b = "10.0.2.0/24"
private_subnet_c = "10.0.3.0/24"

public_subnet_a = "10.0.101.0/24"
public_subnet_b = "10.0.102.0/24"
public_subnet_c = "10.0.103.0/24"