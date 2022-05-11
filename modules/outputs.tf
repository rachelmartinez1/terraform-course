# returns a value and stores it
output "ip_resource" {
    ip = aws_instance.name.public_ip
}

output "vpc" {
    value = aws_vpc.main
}

output "instance" {
    value = aws_instance.name[*].public_ip # splat operator to print a list of the public ips
    value = [for instance in aws_instance.name.public_ip] # or you could use a for loop
}