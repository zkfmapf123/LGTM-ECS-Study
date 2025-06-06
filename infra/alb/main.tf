module "alb" {
    for_each = jsondecode(file("../alb.json"))

    source =  "zkfmapf123/alb/donggyu"

    cluster_attr = {
        is_create_cluster = true
        cluster_name = each.key
    }

    lb_listener_attr = {
        lb_acm_arn = each.value.acm
    }

    lb_listener_tg = {
        tg_name = "${each.key}-default-tg"
        tg_vpc_id = local.network.vpc_id
        tg_port = 80
        tg_protocol = "HTTPS"
        tg_target_type = "ip"
    }

    lb_attr ={
        lb_name = "${each.key}-lb"
        lb_vpc_id = local.network.vpc_id
        lb_sg_ids = [local.sg.lb_sg_id]
        lb_subnet_ids  = values(local.network.webserver_subnets)
        lb_delete_protection = false
    }

    lb_enable_access_logs = {
        is_enable= false
        s3_bucket_id = ""
    }
}

output out {
    value = module.alb
}