variable "type" {
type = map
default = {
ap-south-1 = "t2.micro"
us-east-1 = "t2.nano"
}
}
variable "list" {
type = list
default = ["t2.nano","t2.micro"]
}
