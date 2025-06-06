module "ecs-fargate" {
    for_each = jsondecode(file("../ecs.json"))

  source  = "zkfmapf123/ecs-fargate/donggyu"

  task_role_attr = {
    name = "${each.key}-task-role"
    policy = {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Action" : ["s3:*", "logs:*"],
          "Resource" : "*"
        }
      ]
    }
  }

  execution_role_attr = {
    name = "${each.key}-execution-role"
    policy = {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Action" : ["s3:*", "logs:*"],
          "Resource" : "*"
        }
      ]
    }
  }

  is_use_alb = true

  ecr_attr = {
    is_enable = true
    name      = "${each.key}-repository"
    env       = "test"
  }

  ecs_attr = {
    ecs_name         = "${each.key}-svc"
    ecs_env          = "test"
    ecs_port         = each.value.ecs_port
    ecs_hard_cpu     = 256
    ecs_hard_mem     = 512
    ecs_image_arn    = "public.ecr.aws/p2t6u4a0/zent-utils:latest"
    ecs_os_system    = "LINUX"
    ecs_architecture = "ARM64"
    ecs_cluster      = lookup(local.alb, each.value.lb_name).ecs_cluster_name
  }

  ecs_network_attr = {
    ecs_is_public_ip = false
    ecs_subnet_ids   = values(local.network.was_subnets)
    ecs_sg_ids       = [lookup(local.sg.service_sg_ids, each.value.sg_name), local.network.endpoint_sg_id]
    ecs_vpc_id       = local.network.vpc_id
    ecs_443_listener_arn = lookup(local.alb, each.value.lb_name).listener_443_arn
    ecs_priority = each.value.lb_prioirty,
    ecs_host_header = each.value.lb_host_header
  }

  ecs_health_check = {
    port = each.value.ecs_port
    path = each.value.lb_path
    matcher = "200-399"
    protocol             = "HTTP"
    healthy_threshold    = 3
    unhealthy_threshold  = 3
    timeout              = 30
    interval             = 40 ## greater than timeout
    deregistration_delay = 60
  }
}