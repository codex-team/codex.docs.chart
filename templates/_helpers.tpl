{{/*
Expand the name of the chart.
*/}}
{{- define "codexdocs.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "codexdocs.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "codexdocs.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "codexdocs.labels" -}}
helm.sh/chart: {{ include "codexdocs.chart" . }}
{{ include "codexdocs.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "codexdocs.selectorLabels" -}}
app.kubernetes.io/name: {{ include "codexdocs.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "codexdocs.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "codexdocs.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Returns the available value for certain key in an existing secret (if it exists),
otherwise it generates a random value.
*/}}
{{- define "getValueFromSecret" }}
{{- $len := (default 16 .Length) | int -}}
{{- $obj := (lookup "v1" "Secret" .Namespace .Name).data -}}
{{- if $obj }}
{{- index $obj .Key | b64dec -}}
{{- else -}}
{{- randAlphaNum $len -}}
{{- end -}}
{{- end }}

{{/*
Return codex.docs password
*/}}
{{- define "codexdocs.password" -}}
{{- if empty .Values.auth.password -}}
{{- include "getValueFromSecret" (dict "Namespace" .Release.Namespace "Name" (include "codexdocs.fullname" .) "Length" 20 "Key" "docs-password")  -}}
{{- else -}}
{{- .Values.auth.password -}}
{{- end -}}
{{- end -}}

{{/*
Get the password secret.
*/}}
{{- define "codexdocs.secretName" -}}
{{- if .Values.auth.existingSecret -}}
{{- printf "%s" .Values.auth.existingSecret -}}
{{- else -}}
{{- printf "%s" (include "codexdocs.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Get the password key to be retrieved from secret.
*/}}
{{- define "codexdocs.secretPasswordKey" -}}
{{- if and .Values.auth.existingSecret .Values.auth.existingSecretPasswordKey -}}
{{- printf "%s" .Values.auth.existingSecretPasswordKey -}}
{{- else -}}
{{- printf "docs-password" -}}
{{- end -}}
{{- end -}}