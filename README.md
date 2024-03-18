# mtl-test

1. Dockerfile 
    - path : ./app-no-ops/Dockerfile
2. Docker Hub 
    - url : https://hub.docker.com/r/beerwarin/app-no-ops
3. Helm Chart -> 
    - path : ./helm/deploy-app/ 
    - Values file : ./helm/deploy-app/app-no-ops.yaml
        ** for choose deployment type value is deployType: # single, canary, bluegreen
4. IaC Code Terraform create EKS 
    - path : ./terraform/
5. IaC Code Terraform create policy
    - ???
6. ArgoCD Yaml files and instruction 
    - yaml file : /argocd/argo-app-no-ops.yaml
    - command
        - kubectl apply -f ./argocd/argo-app-no-ops.yaml
        - helm template ./helm/deploy-app/ -f ./helm/deploy-app/app-no-ops.yaml > ./k8s-deploy-app/k8s-deploy.yaml
        - argocd app sync app-no-ops
7. Github Actions workflow (yml file) or diagram
    - ??
8. Diagram
    - 