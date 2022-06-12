installCRDs: false

server:
  ingress:
    enabled: "${ argocd_ingress_enabled }"
    annotations:
      kubernetes.io/ingress.class: "${ argocd_ingress_class }"
      kubernetes.io/tls-acme: "${ argocd_ingress_tls_acme_enabled }"
      ingress.kubernetes.io/rewrite-target: "/"
      cert-manager.io/cluster-issuer: "zerossl"
      nginx.ingress.kubernetes.io/ssl-passthrough: "${ argocd_ingress_ssl_passthrough_enabled }"
    hosts:
      - "${ argocd_server_host }"
    tls:
      - secretName: "${ argocd_ingress_tls_secret_name }"
        hosts:
          - "${ argocd_server_host }"

    certificate:
      - enabled: true 
      - name: zerossl
      - secretName: "${ argocd_ingress_tls_secret_name }"
  config:
    url: "https://${ argocd_server_host }"
    admin.enabled: "false"
    dex.config: |
      connectors:
        - type: github
          id: github
          name: GitHub
          config:
            clientID: "${ argocd_github_client_id }"
            clientSecret: "${ argocd_github_client_secret }"
