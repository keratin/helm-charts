{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "keratin-authn-server.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "keratin-authn-server.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "keratin-authn-server.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "keratin-authn-server.labels" -}}
helm.sh/chart: {{ include "keratin-authn-server.chart" . }}
{{ include "keratin-authn-server.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Selector labels
*/}}
{{- define "keratin-authn-server.selectorLabels" -}}
app.kubernetes.io/name: {{ include "keratin-authn-server.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/*
Redis master container host
*/}}
{{- define "redis.masterFullname" -}}
{{- printf "%s-%s" .Release.Name  "redis-master" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Redis master connection string
*/}}
{{- define "redis.masterConnectString" -}}
{{- printf "redis://%s-%s:6379/0" .Release.Name  "redis-master" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "database.masterFullname" -}}
{{- printf "mysql://%s-%s:3306/0" .Release.Name  "-database" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "envs" -}}
            {{- range $key, $value := $.Values.env }}
            - name: {{ $key }}
              value: {{ $value | quote }}
            {{- end }}
            - name: AUTHN_URL
              value: {{ required "A valid .Values.appSettings.authnUrl entry required!" .Values.appSettings.authnUrl | quote }}
            - name: APP_DOMAINS
              value: {{ required "A valid .Values.appSettings.appDomains entry required!" .Values.appSettings.appDomains | quote }}
            - name: PUBLIC_PORT
              value: "3000"
            - name: HTTP_AUTH_USERNAME
              value: {{ required "A valid .Values.internalApi.username entry required!" .Values.internalApi.username | quote }}
            - name: HTTP_AUTH_PASSWORD
              value: {{ required "A valid .Values.internalApi.password entry required!" .Values.internalApi.password | quote }}
            - name: PORT
              value: "3001"
            - name: SECRET_KEY_BASE
              value: {{ required "A valid .Values.secretKeyBase entry required!" .Values.secretKeyBase | quote }}            
            {{- if .Values.persistence.databaseUrl }}
            - name: DATABASE_URL
              value: {{ .Values.persistence.databaseUrl }}
            {{- else }}
              {{- if .Values.mariadb.enabled }} 
            - name: DATABASE_PASSWORD
              valueFrom:
                secretKeyRef:
                  name: {{ .Release.Name }}-mariadb
                  key: mariadb-password
            - name: DATABASE_URL
              value: "mysql://{{ .Values.mariadb.db.user }}:$(DATABASE_PASSWORD)@{{ .Release.Name }}-mariadb:{{ .Values.mariadb.service.port }}/{{ .Values.mariadb.db.name }}"
              {{- end }}
            {{- end }}
            {{- if .Values.redis.enabled }}
            - name: REDIS_URL
              value: {{ include "redis.masterConnectString" . | quote }} 
            {{- else }}
            - name: REDIS_URL
              value: {{ .Values.persistence.redisUrl | quote }} 
            {{- end }}
{{- end -}}