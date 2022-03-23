# SPIRE Token Generator
Generating [Spire Server](https://spiffe.io/docs/latest/spiffe-about/spiffe-concepts/) token as initContainer on kubernetes. This container image passes the token as k8s secret for HPE Swarm Learning.

# Usage
See [example](examples/k8s.yaml).  
You need to create *ServiceAccount*, *Role*, *RoleBinding*, *Secret* before running this container to get token and save it.
The example for HPE Swarm Learning is [here](examples/swarm.yaml).

## Environment Values
| KEY | VALUE | DESCRIPTION | REQUIRED | NOTE |
| :---: | :---: | :---: | :---: | :---: |
| SPIRE\_POD\_LABEL | Spire Server Pod Label | To identify Spire Server Pod to execute *kubectl exec* for getting the token. | YES | Spire Server is in same namespace in [example](examples/k8s.yaml). |
| SPIRE\_SPIFFE\_ID | SPIFFE ID  | SPIFFE ID which you want the token. | YES |  |
| SPIRE\_TOKEN\_SECRET\_NAME | Secret Name | To save token as kubernetes secret. | YES |  |
|  |  |  |  |  |

## Container Image Locations
- [Docker Hub](https://hub.docker.com/repository/docker/fideltak/spire-token-generator)