{{/*
Chart name truncated to 63 characters.
*/}}
{{- define "acm-observability.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Fully qualified app name.
*/}}
{{- define "acm-observability.fullname" -}}
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
Chart version label.
*/}}
{{- define "acm-observability.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels.
*/}}
{{- define "acm-observability.labels" -}}
helm.sh/chart: {{ include "acm-observability.chart" . }}
{{ include "acm-observability.selectorLabels" . }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
{{- end }}

{{/*
Selector labels.
*/}}
{{- define "acm-observability.selectorLabels" -}}
app.kubernetes.io/name: {{ include "acm-observability.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Observability namespace.
*/}}
{{- define "acm-observability.namespace" -}}
{{- .Values.namespace | default "open-cluster-management-observability" }}
{{- end }}

{{/*
Thanos object storage config (IRSA mode - no credentials).
*/}}
{{- define "acm-observability.thanosObjectStorageConfig" -}}
{{- if .Values.objectStorage.rawConfig }}
{{- .Values.objectStorage.rawConfig }}
{{- else }}
type: s3
config:
  bucket: {{ required "objectStorage.s3.bucket is required" .Values.objectStorage.s3.bucket }}
  endpoint: {{ required "objectStorage.s3.endpoint is required" .Values.objectStorage.s3.endpoint }}
  insecure: false
  {{- if .Values.objectStorage.s3.region }}
  region: {{ .Values.objectStorage.s3.region }}
  {{- end }}
{{- end }}
{{- end }}

{{/*
IRSA service account annotations for Thanos components.
*/}}
{{- define "acm-observability.irsaAnnotations" -}}
{{- if .Values.objectStorage.irsaRoleArn }}
eks.amazonaws.com/role-arn: {{ .Values.objectStorage.irsaRoleArn }}
{{- end }}
{{- end }}
