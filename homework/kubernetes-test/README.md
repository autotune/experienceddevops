# SRE/DevOps Challenge

## Overview
This challenge will test the following skills:
* Kubernetes orchestration
* CI systems
* REST APIs
* Scripting
* Monitoring
* Allow at least 3 hours to complete each part.

Do not be discouraged if you are unable to complete aspects of the challenge, it is designed to test all levels of ability.

## Rules
1. Complete the challenge on your own.
2. Referencing online resources is expected. You should comment with a reference when you do.
3. You are encouraged to ask us clarifying questions. (Your recruiter will forward the questions, so expect delays in response.)
4. Note any deviations from the specification.
5. Be prepared to talk about the challenge in later interview rounds.

## Deliverables
Provide a single archive of all challenge files.
Use the following layout:
* part-a/
* k8s-manifests/
* manifests for Rocket Chat, GitLab
* webhook-app/
* all files pertaining to the GitLab webhook 🡪 Rocket Chat message application
* README.md
* part-b/
* prometheus-grafana-values.yaml
* webhook-app-service-monitor.yaml
* webhook-app-dashboard.yaml
* prometheus-metrics-adaptor(-values).yaml
* README.md

Each part’s README should include:
* Instructions on how to run each part of the challenge. 
* Brief description of rationale behind each tool/language/framework of choice.
* Brief description of key challenges. It’s okay to say you are not sure what you did was the best way to solve it. Be sure to justify your decision.
* Note any caveats and potential failure scenarios.
* Note what you would do differently in a production environment.

## Part A, GitLab and Webhooks
1. Create and deploy k8s manifests that contain the following applications using publicly available images from Docker Hub:
* Rocket Chat
* GitLab

Do not use a manifest package framework (e.g. Helm) for this step.
2. Write a REST API application that, when sent a GitLab webhook, sends the git commit SHA to a Rocket Chat user as a direct message (language of your choosing). Push this to a project on your GitLab instance created above.
3. Write a Dockerfile and k8s manifest(s) for that application and configure GitLab CI such that it builds and pushes the image to the bundled GitLab container registry, then deploys to your k8s cluster.
4. Configure GitLab CI to send a webhook to your deployed application, triggered by commits to the application’s GitLab project.

## Part B, Monitoring and Custom Metrics
1. Deploy the Prometheus and Grafana to your k8s cluster using the kube-prometheus-stack Helm chart, saving settings to a `values.yaml`.
2. Add a Prometheus metrics endpoint to your REST API that exposes a count of received webhooks.
3. Configure Prometheus to scrape that endpoint using ServiceMonitor, and create a provisioned Grafana dashboard for the metric.
4. Create another custom metric for your REST API that exposes a count of in-flight requests.
5. Deploy a custom metrics adaptor for Prometheus, saving your k8s manifest(s) and/or chart `values.yaml`.
6. Add an HPA manifest to your REST API that’s sensitive to the custom metric from step 1.

