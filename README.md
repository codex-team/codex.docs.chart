# codex.docs.chart
Helm chart for deploying CodeX Docs

## Installing

In order to install this chart, run the following command:

```bash
helm upgrade codex-docs oci://ghcr.io/codex-team/codex.docs.chart/codex-docs --version <specify_latest_version_here> --install
```

## Running locally

Execute the following commands from the repository root folder:
```
helm install codex-docs ./ -n codex-docs --create-namespace
```

You can proxy pod to http://localhost:3000
```
kubectl port-forward $(kubectl get pods -n codex-docs -o jsonpath="{.items[0].metadata.name}") 3000:3000 -n codex-docs
```

For local deployment you can use minikube:
```
minikube service codex-docs -n codex-docs --url
```