# Variables


### Declaring Variables

```

 variables "<variable_name>" {
    type = [string | bool | number | map(string) | list() | object]
    default = "Default value of the variable"
    Description = "Describe your variables"
 }

```

### Variables Types

1. String type

    ```

        variable "instance_type" {
            type    = string
            default = "t2.micro"
            description = "Variable description"
        }

    ```
2. Boolean type

    ```

        variable "boolean" {
            type    = bool
            default = ture | false
            description = "Variable description"
        }
        
    ```

3. Number type
    ```

        variable "instance_count" {
            type    = number
            default = 2
            description = "Variable description"
        }
        
    ```
4. List type
    ```
        variable "azs" {
            type    = list(string)
            default = ["us-east-1a", "us-east-1b"]
            description = "Variable description"
        }
        
    ```
    **Usage:** azs = var.azs
    
5. Map Type
    ```
        variable "tags" {
            type    = map(...)
            default = {
                Environment = "dev"
                Project     = "my-app"
            }
            
            description = "Variable description"
        }
        
    ```
    **Usage:** tags = var.tags

6. Object Type
    ```
        variable "db_config" {
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
        
    ```
    **Usage:** engine = var.db_config.engine
    
7. Sensitive Type
        
    Mark a variable as sensitive to hide it in the CLI output:
    
    ```
        variable "password" {
            type    = string
            default = "Mypassword
            sensitive = true
            description = "Variable description"
        }
        
    ```