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

{{/*
Ingress url for tunnels
*/}}
{{- define "codefresh-tunnel-server.tunnels-ingress-host" -}}
  {{- if .Values.tunnels.ingress -}}
    {{- if .Values.tunnels.ingress.host -}}
      {{- if .Values.tunnels.subdomainHost -}}
        {{- if not (hasSuffix .Values.tunnels.subdomainHost .Values.tunnels.ingress.host) -}}
          {{ fail "Ingress host for tunnels must end with subdomain" }}
        {{- end -}}
      {{- end -}}
      {{ print .Values.tunnels.ingress.host | quote }}
    {{- else if .Values.tunnels.subdomainHost -}}
      {{ printf "%s.%s" "*" .Values.tunnels.subdomainHost | quote }}
    {{- else -}}
      {{ fail "subdomainHost or host must be provided for tunnels ingress"}}
    {{- end -}}
  {{- end -}}
{{- end -}}


{{/*
Return true if a TLS secret object should be created for tunnels ingress
*/}}
{{- define "codefresh-tunnel-server.tunnels.createTlsSecret" -}}
{{- if and .Values.tunnels.ingress.tls.enabled (not .Values.tunnels.ingress.tls.existingSecret) }}
    {{- true -}}
{{- end -}}
{{- end -}}

{{/*
Return true if a TLS secret object should be created for tunnel server
*/}}
{{- define "codefresh-tunnel-server.createTlsSecret" -}}
{{- if and .Values.ingress.tls.enabled (not .Values.ingress.tls.existingSecret) }}
    {{- true -}}
{{- end -}}
{{- end -}}

{{/*
Return the secret containing TLS certificates for tunnels ingress
*/}}
{{- define "codefresh-tunnel-server.tunnels.tlsSecretName" -}}
{{- $secretName := .Values.tunnels.ingress.tls.existingSecret -}}
{{- if $secretName -}}
    {{- printf "%s" (tpl $secretName $) -}}
{{- else -}}
    {{- printf "%s-tunnels-cert" (include "codefresh-tunnel-server.name" .) -}}
{{- end -}}
{{- end -}}

{{/*
Return the secret containing TLS certificates for tunnel server
*/}}
{{- define "codefresh-tunnel-server.tlsSecretName" -}}
{{- $secretName := .Values.ingress.tls.existingSecret -}}
{{- if $secretName -}}
    {{- printf "%s" (tpl $secretName $) -}}
{{- else -}}
    {{- printf "%s-cert" (include "codefresh-tunnel-server.name" .) -}}
{{- end -}}
{{- end -}}