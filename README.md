# AWS monitoring

Example usage:

```
provider "aws" {
  region = "us-east-1"
}

module "monitoring" {
  source       = "TaitoUnited/monitoring/aws"
  version      = "1.0.0"

  name         = "my-infrastructure"

  # Messaging
  messaging_app              = "slack"
  messaging_webhook          = "https://..."
  messaging_critical_channel = "critical"
  messaging_builds_channel   = "builds"

  # TODO: implement alerts
  alerts       = yamldecode(file("${path.root}/../infra.yaml"))["alerts"]
}
```

Example YAML:

```
# TODO: implement alerts
alerts:
  - name: ingress-response-time
    type: log
    channels: [ "monitoring" ]
    rule: >
      resource.type = "k8s_container"
      resource.labels.namespace_name = "ingress-nginx"
      jsonPayload.responseTimeS >= 3
  - name: ingress-response-status
    type: log
    channels: [ "monitoring" ]
    rule: >
      resource.type = "k8s_container"
      resource.labels.namespace_name = "ingress-nginx"
      jsonPayload.status >= 500
  - name: container-errors
    type: log
    channels: [ "monitoring" ]
    rule: >
      resource.type = "k8s_container"
      severity >= ERROR
```

YAML attributes:

- See variables.tf for all the supported YAML attributes.

Combine with the following modules to get a complete infrastructure defined by YAML:

- [Admin](https://registry.terraform.io/modules/TaitoUnited/admin/aws)
- [DNS](https://registry.terraform.io/modules/TaitoUnited/dns/aws)
- [Network](https://registry.terraform.io/modules/TaitoUnited/network/aws)
- [Compute](https://registry.terraform.io/modules/TaitoUnited/compute/aws)
- [Kubernetes](https://registry.terraform.io/modules/TaitoUnited/kubernetes/aws)
- [Databases](https://registry.terraform.io/modules/TaitoUnited/databases/aws)
- [Storage](https://registry.terraform.io/modules/TaitoUnited/storage/aws)
- [Monitoring](https://registry.terraform.io/modules/TaitoUnited/monitoring/aws)
- [Integrations](https://registry.terraform.io/modules/TaitoUnited/integrations/aws)
- [PostgreSQL privileges](https://registry.terraform.io/modules/TaitoUnited/privileges/postgresql)
- [MySQL privileges](https://registry.terraform.io/modules/TaitoUnited/privileges/mysql)

Similar modules are also available for Azure, Google Cloud, and DigitalOcean. All modules are used by [infrastructure templates](https://taitounited.github.io/taito-cli/templates#infrastructure-templates) of [Taito CLI](https://taitounited.github.io/taito-cli/). TIP: See also [AWS project resources](https://registry.terraform.io/modules/TaitoUnited/project-resources/aws), [Full Stack Helm Chart](https://github.com/TaitoUnited/taito-charts/blob/master/full-stack), and [full-stack-template](https://github.com/TaitoUnited/full-stack-template).

Contributions are welcome!
