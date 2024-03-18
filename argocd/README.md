## install argocd
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

kubectl port-forward svc/argocd-server -n argocd 8080:443

argocd admin initial-password -n argocd

argocd login localhost:8080
argocd account update-password

## create application
argocd app create guestbook --repo https://github.com/wtrakonkun/mtl-test.git --path helm/deploy-app --dest-server https://kubernetes.default.svc --dest-namespace default

## generate k8s
helm template . -f app-no-ops.yaml >> ../../k8s-deploy-app/k8s-deploy.yaml
argocd app sync app-no-ops