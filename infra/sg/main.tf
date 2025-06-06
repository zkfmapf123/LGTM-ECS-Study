resource "aws_security_group" "lb_sg" {
  name = "monitoring-lb-sg"
  description = "monitoring-lb-sg"
  vpc_id = local.network.vpc_id

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "service_sg" {
  for_each = jsondecode(file("../ecs.json"))

  name = "${each.key}-service-sg"
  description = "${each.key}-service-sg"
  vpc_id = local.network.vpc_id

  ingress {
    from_port = 3000
    to_port = 3000
    protocol = "tcp"
    security_groups = [aws_security_group.lb_sg.id]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  depends_on = [ aws_security_group.lb_sg ]
}

output "out" {
    value = {
        lb_sg_id = aws_security_group.lb_sg.id
        service_sg_ids = {
          for k, v in aws_security_group.service_sg : k => v.id
        }
    }
}