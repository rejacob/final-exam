{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "test.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}-{{ .Values.environment }}
{{- end -}}

{{- define "test.namespace" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 4 | trimSuffix "-" -}}-{{ .Values.environment }}
{{- end -}}

{{- define "test.containerName" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 4 | trimSuffix "-" -}}-{{ .Values.environment }}
{{- end -}}

{{- define "test.deploymentName" -}}
deployment-{{ include "test.containerName" . }}
{{- end -}}

{{- define "test.deploymentLabels" -}}
app: {{ include "test.containerName" . }}
deployment: {{ include "test.deploymentName" . }}
{{- end -}}

{{- define "test.deploymentPods.labels" -}}
app: {{ include "test.containerName" . }}
{{- end -}}

{{- define "test.serviceaccount" -}}
serviceaccount-{{- include "test.name" . -}}
{{- end -}}

{{- define "test.service" -}}
svc-{{- include "test.name" . -}}
{{- end -}}

{{- define "test.ingress" -}}
ingress-{{- include "test.name" . -}}
{{- end -}}

{{- define "test.ingress.annotations" -}}
kubernetes.io/ingress.class: alb
alb.ingress.kubernetes.io/certificate-arn: "{{ .Values.awsACMArn }}"
alb.ingress.kubernetes.io/listen-ports: '[{ "HTTP": 80 }, { "HTTPS": 443 }]'
alb.ingress.kubernetes.io/security-groups: {{ .Values.awsSGALB }}
alb.ingress.kubernetes.io/actions.ssl-redirect: '{"Type": "redirect", "RedirectConfig": { "Protocol": "HTTPS", "Port": "443", "StatusCode": "HTTP_301"}}'
alb.ingress.kubernetes.io/ssl-policy: ELBSecurityPolicy-TLS-1-2-Ext-2018-06
{{- end -}}

{{- define "test.hpa" -}}
hpa-{{- include "test.name" . -}}
{{- end -}}