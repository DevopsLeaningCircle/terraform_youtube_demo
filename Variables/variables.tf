variable "string_type" {
  type = string
  default = "t2.micro"
  description = "Instance family"
}

variable "boolean_type" {
  type = bool
  default = false
  
}

variable "number_type" {
  type = number
  default = 0
  description = "number type"
}

variable "list_type" {
  type = list(string)
  default = [ "us-east-1a", "us-east-1b" ]
}

variable "map_type" {
  type = map(string)
  default = {
    "ENV" = "dev"
    "Name" = "terraform"
  }
}

variable "object_type" {
    type = object({
            engine   = string
            version  = string
            instance = string
        })
        
        default = {
            engine   = "mysql"
            version  = "8.0"
            instance = "db.t3.micro"
        }
        
        
        description = "Variable description"
    }