################################################################################################################################################################
# Naming and labeling
################################################################################################################################################################

# -----------------------
# Server names and labels
# -----------------------

{{/*
Expand the name of the chart.
*/}}
{{- define "codefresh-tunnel-server.name" -}}
{{- default "codefresh-tunnel-server" .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "codefresh-tunnel-server.selectorLabels" -}}
app: {{ include "codefresh-tunnel-server.name" .}}
release: {{ .Release.Name }}
{{- end }}

{{- define "codefresh-tunnel-server.labels" -}}
app: {{ include "codefresh-tunnel-server.name" .}}
release: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "codefresh-tunnel-server.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "codefresh-tunnel-server.name" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}
# -----------------------
# router names and labels
# -----------------------
{{/*
Expand the name of the chart.
*/}}
{{- define "codefresh-tunnel-router.name" -}}
{{- default "codefresh-tunnel-router" .Values.scaling.router.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "codefresh-tunnel-router.selectorLabels" -}}
app: {{ include "codefresh-tunnel-router.name" .}}
release: {{ .Release.Name }}
{{- end }}

{{- define "codefresh-tunnel-router.labels" -}}
app: {{ include "codefresh-tunnel-router.name" .}}
release: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "codefresh-tunnel-router.serviceAccountName" -}}
  {{- if .Values.scaling.router.serviceAccount.create }}
{{- default (include "codefresh-tunnel-router.name" .) .Values.scaling.router.serviceAccount.name }}
  {{- else }}
{{- default "default" .Values.scaling.router.serviceAccount.name }}
  {{- end }}
{{- end }}

################################################################################################################################################################
# Template logic funtions
################################################################################################################################################################
{{/*
Set server deployment scale in case there is scaling or there is not
*/}}
{{- define "codefresh-tunnel-server.deploymentScale" -}}
  {{- if .Values.scaling.enabled -}}
    {{- if not .Values.scaling.autoscaling.enabled -}}
replicas: {{ .Values.scaling.replicaCount }}
    {{- end -}}
  {{- else -}}
replicas: 1
  {{- end -}}
{{- end -}}

{{/*
Determine redis url environment variable
*/}}
{{- define "codefresh-tunnel-server.redis-url-env" -}}
  {{- if .Values.scaling.enabled -}}
    {{- if .Values.scaling.redisURL.secretKeyRef -}}
- name: REDIS_URL
  valueFrom:
      {{- with .Values.scaling.redisURL.secretKeyRef }}
    secretKeyRef:
{{ . | toYaml | indent 6}}
      {{- end -}}
    {{- else if .Values.scaling.redisURL.url -}}
- name: REDIS_URL
  value: {{ .Values.scaling.redisURL.url }}
    {{- else }}
      {{ fail "Scaling requires redisURL to be set" }}
    {{- end -}}
  {{- end -}}
{{- end -}}

