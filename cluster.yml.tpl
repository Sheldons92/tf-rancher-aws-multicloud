cluster_name: ${cluster_name}
ssh_agent_auth: true

ignore_docker_version: true
nodes:
%{ for k, v in nodes ~}
    - address: ${nodes[k].public_ip}
      internal_address: ${nodes[k].private_ip}
      user: ubuntu
      role:
%{ for role in nodes[k].roles ~}
        - ${role}
%{ endfor ~}
%{ endfor ~}
ingress:
  provider: nginx
kubernetes_version: ${kubernetes_version}
monitoring:
  provider: metrics-server
  replicas: 1
cloud_provider:
  name: "aws"
network:
  mtu: 0
  options:
    flannel_backend_type: vxlan
  plugin: canal
services:
  etcd:
    backup_config:
      enabled: true
      interval_hours: 12
      retention: 6
      safe_timestamp: false
    creation: 12h
    extra_args:
      election-timeout: 5000
      heartbeat-interval: 500
    gid: 0
    retention: 72h
    snapshot: false
    uid: 0
  kube_api:
    always_pull_images: false
    pod_security_policy: false
    service_node_port_range: 30000-32767
upgrade_strategy:
  drain: false
  max_unavailable_controlplane: '1'
  max_unavailable_worker: 10%
  node_drain_input:
    delete_local_data: false
    force: false
    grace_period: -1
    ignore_daemon_sets: true
    timeout: 120