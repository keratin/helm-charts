# Keratin helm charts

This chart makes it easier to deploy [keratin authn server](https://keratin.tech/) to k8s cluster.

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

## Installation 

Add repository first: 

```bash
helm repo add keratin https://keratin.github.io/helm-charts
```

Create values.yaml file as described above.

Install helm chart into your kubernetes with the following command (helm3)

```bash
helm upgrade --install --atomic -n <namespace> -f ./values.yaml <release name> keratin/keratin-authn-server
```


## Configuration

The following table lists the configurable parameters of the Adminer chart and the default values.

| Parameter                         | Description                                                             | Default                     |
| --------------------------------- | ----------------------------------------------------------------------- | --------------------------- |
| **Image**                                                                                                                                 |
| `image.repository`                | Image                                                                   | `keratin/authn-server`      |
| `image.pullPolicy`                | Image pull policy                                                       | `IfNotPresent`              |
| **Config**                                                                                                                                |
| `appSettings.authnUrl`            | The base URL of the AuthN service                                       | `-`                         |
| `appSettings.appDomains`          | Comma-delimited list of application trusted domains                     | `-`                         |
| `internalApi.username`            | HTTP Basic Auth username to access internal API                         | `-`                         |
| `internalApi.password`            | HTTP Basic Auth password to access internal API                         | `-`                         |
| `secretKeyBase`                   | Random string to derive HMAC keys used by AuthN from                    | `-`                         |
| **Service**                                                                                                                               |
| `service.type`                    | Service type                                                            | `ClusterIP`                 |
| `service.port`                    | The service port                                                        | `80`                        |
| **Service for internal API**                                                                                                              |
| `serviceInternal.type`            | Service type                                                            | `ClusterIP`                 |
| `serviceInternal.port`            | The service port                                                        | `8080`                      |
| **Ingress**                                                                                                                               |
| `ingress.enabled`                 | Enables Ingress                                                         | `false`                     |
| `ingress.annotations`             | Ingress annotations                                                     | `{}`                        |
| `ingress.labels`                  | Custom labels                                                           | `{}`                        |
| `ingress.hosts`                   | Ingress accepted hostnames                                              | `[]`                        |
| `ingress.tls`                     | Ingress TLS configuration                                               | `[]`                        |
| **Ingress for internal API** (if you have services outside of kubernetes cluster)                                                         |
| `ingressInternal.enabled`         | Enables Ingress                                                         | `false`                     |
| `ingressInternal.annotations`     | Ingress annotations                                                     | `{}`                        |
| `ingressInternal.labels`          | Custom labels                                                           | `{}`                        |
| `ingressInternal.hosts`           | Ingress accepted hostnames                                              | `[]`                        |
| `ingressInternal.tls`             | Ingress TLS configuration                                               | `[]`                        |
| **Resources**                                                                                                                             |
| `resources`                       | CPU/Memory resource requests/limits                                     | `{}`                        |
| **Tolerations**                                                                                                                           |
| `tolerations`                     | Add tolerations                                                         | `[]`                        |
| **NodeSelector**                                                                                                                          |
| `nodeSelector`                    | node labels for pod assignment                                          | `{}`                        |
| **Affinity**                                                                                                                              |
| `affinity`                        | node/pod affinities                                                     | `{}`                        | 

## Credits

Initially inspired from https://github.com/mogaal/helm-charts/tree/master/adminer.

## Contributing

Feel free to contribute by making a [pull request](https://github.com/kratin/helm-charts/pull/new/master).

Please read the official [Contribution Guide](https://github.com/helm/charts/blob/master/CONTRIBUTING.md) from Helm for more information on how you can contribute to this Chart.

## License

[Apache License 2.0](LICENSE.md)