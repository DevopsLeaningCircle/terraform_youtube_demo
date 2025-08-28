# Loops, Expression, and Functions

## Loops

### count

Used to create multiple instances of a resource by simply repeating it. Its index-based (starts from 0)

**Example**

    resource "aws_instance" "example" {
        count         = 3
        ami           = "ami-123456"
        instance_type = "t2.micro"
        tags = {
            Name = "server-${count.index}"
        }
    }


### for each
More flexible than count, works with maps or sets. each resource gets a key, so you don't have to rely on index numbers.

**Example**

    resource "aws_instance" "example" {
        for_each      = {
            dev  = "t2.micro"
            prod = "t2.medium"
        }

        ami           = "ami-123456"
        instance_type = each.value

        tags = {
            Name = each.key
        }
    }


### Dynamic Blocks

Used when you want to conditionally generate nested blocks(e.g., security_groups_rules, ingress, etc).

**Example**

    variable "ingress_rules" {
        default = [
            { port = 22,  protocol = "tcp" },
            { port = 80,  protocol = "tcp" },
            { port = 443, protocol = "tcp" }
        ]
    }

    resource "aws_security_group" "example" {
        name        = "example-sg"
        description = "Security group with dynamic ingress rules"
        vpc_id      = "vpc-123456"

        dynamic "ingress" {
            for_each = var.ingress_rules
            content {
            from_port   = ingress.value.port
            to_port     = ingress.value.port
            protocol    = ingress.value.protocol
            cidr_blocks = ["0.0.0.0/0"]
            }
        }
    }


## Expression

Expressions are used to compute or refeence values dynamically in Terraform.

### References

Referencing variables, resources, outputs:

**Example**

    ami           = var.ami_id
    instance_type = aws_instance.web.instance_type


### String Interpolation

**Example**
    tags = {
        Name = "${var.env}-server"
    }


### Conditionals Expression

Ternary operator:

    instance_type = var.env == "prod" ? "t2.large" : "t2.micro"

### For Expression

Transform collections:

    [for name in var.names : upper(name)]

if var.names == ["dev", "qa"], result = ["DEV", "QA"]

Fileter with if:

    [for n in var.names : n if n != "qa"]

### Splat Expression

When multiple resources exist:

    aws_instance.example[*].id

Collects all IDs into a list.

## Terrform Function

Terraform includes many built-in function (no user-defined functions yet).

### String Functions

    upper("hello")         # "HELLO"
    lower("WORLD")         # "world"
    replace("hello","h","H") # "Hello"
    join("-", ["a","b"])   # "a-b"
    split(",", "a,b,c")    # ["a","b","c"]


### Numeric Fucntions

    max(1, 5, 3)   # 5
    min(2, 8, 6)   # 2
    floor(3.7)     # 3
    ceil(3.1)      # 4

### Collection Fucntions

    length(var.names)            # number of elements
    element(var.names, 1)        # second element
    contains(var.names, "dev")   # true/false
    merge(map1, map2)            # merge two maps
    lookup(var.map, "key", "default") # safe lookup


### Encoding & Filesytem

    file("user_data.sh")   # reads file content
    base64encode("text")   # encode
    base64decode("dGVzdA==") # decode


### Date/Time Functions

    timestamp()   # current UTC time
    formatdate("YYYY-MM-DD", timestamp())

### Crypto Fucntion

    md5("hello")
    sha256("data")
    uuid()



# Refere Terraoform Official documents for more function - https://developer.hashicorp.com/terraform/language/functions