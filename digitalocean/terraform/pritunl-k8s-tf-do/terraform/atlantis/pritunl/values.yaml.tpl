image:
  registry: ${DOCKER_REGISTRY}  
  repository: autotune/pritunl-k8s-tf-do/autotune/pritunl-k8s-tf-do
  tag: ${DOCKER_TAG} 
  pullPolicy: Always
  pullSecret: "${DOMAIN_NAME}-docker-login"
  domainname: "${DOMAIN_NAME}"
  secretname: "${DOMAIN_NAME}-pritunl-tls"

# This should match whatever the 'mongodb' service is called in the cluster.
# DNS should be able to resolve the service by this name for Pritunl to function.
mongoService: "pritunl-mongodb"

# Change these as you see fit.
ports:
  http: 80
  vpn: 1194
  webui: 80 

# This must be enabled when using Pritunl due to the rights that iptables will need in the Pritunl pods.
privileged:
  enabled: true

# This will adjust the replicas that are deployed as a part of the Pritunl deployment.
# This is '3' by default. Your Pritunl cluster number will be affected by this.
replicaCount: 3

# If 'type' here is 'LoadBalancer', these annotations are necessary to properly use an ELB if deploying this chart in AWS, so they'll automatically get used.
# Be sure to add the appropriate domain name, cert ARN, and ssl-negotiation-policy (a default is used here).
service:
  annotations:
  type: ClusterIP

tty:
  enabled: true

# Health Checks
livenessProbe:
  enabled: true
  initialDelaySeconds: 30
  periodSeconds: 10
  timeoutSeconds: 5
  failureThreshold: 6
  successThreshold: 1

readinessProbe:
  enabled: true
  initialDelaySeconds: 5
  periodSeconds: 10
  timeoutSeconds: 5
  failureThreshold: 6
  successThreshold: 1
