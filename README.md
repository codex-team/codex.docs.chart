# codex.docs.chart
Helm chart for deploying CodeX Docs

## Running

Execute the following commands from the repository root folder:
```
kubectl create ns codex-docs
helm install codex-docs ./ -n codex-docs
```

You can proxy pod to http://localhost:3000
```
kubectl port-forward $(kubectl get pods -n codex-docs -o jsonpath="{.items[0].metadata.name}") 3000:3000 -n codex-docs
```