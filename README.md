# Keratin helm charts

This chart makes it easier to deploy [keratin auth server](https://keratin.tech/) to k8s cluster.

*This is a beta version of the chart. Feel free to use it and provide feedback*

## Chart configuration

Minimal values file:
```
appSettings:
  authnUrl: "https://auth.example.com"
  appDomains: "app.example.com,app2.example.com"
 
internalApi:
  username: "user for internal api"    
  password: "password for internal api"

secretKeyBase: "random secret string"
```

Random secret string and password can be generated for example with the following command:

```
openssl rand -base64 48
```

In this case redis and mariadb instances will be deployed automatically from bitnami charts.

If you use managed versions of redis or database you can override these settings with the following values:
```
persistence:
  databaseUrl: "mysql://user:password@host:3306/dbname"
  redisUrl: "redis://host:6379/0"


redis:
  enabled: false

mariadb:
  enabled: false
```

## Building the chart

You need to build the chart only if you fork it and modify the templates. If you just install the chart - these steps are not needed.

To download dependencies

```
helm dep up ./keratin-authn-server/
```
