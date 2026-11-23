# Cloud Build trigger for GKE

The trigger builds an image from your repository, pushes it with the Cloud Build ID as its tag, and uses the manifests in your repository to deploy that image to GKE.

## Prerequisites

- Terraform 1.3 or newer.
- A Google Cloud project with Cloud Build, Artifact Registry, and GKE APIs enabled.
- A repository already connected through Cloud Build's legacy repository integration. Use its connected name for `cloud_build_repository_name` if it differs from the GitHub repository slug.
- An existing GKE cluster. Set `region` to the cluster's location.
- An Artifact Registry repository configured to serve the project's `gcr.io` image path. The Cloud Build execution service account needs permission to write images and deploy to the target cluster.
- Kubernetes manifests with an image reference matching the image repository, so `gke-deploy` can substitute the build's image.

## Configure and preview

Use Application Default Credentials for the Terraform runner, for example with `gcloud auth application-default login`. Supply a local credential file path through `sa_token` only when needed. Keep the credential file outside the repository.

From this directory, update the values in `terraform.tfvars` or override them in an ignored `local.auto.tfvars`. Set `sa_token = null` for Application Default Credentials if the tracked configuration contains a path.

The default trigger matches `main` only. Set `branch_pattern` to change it. The default Dockerfile is `Dockerfile`, the build context is `.`, and the manifests directory is `kubernetes/prod`. These paths are relative to the repository checkout.

```sh
terraform init
terraform fmt -check
terraform validate
terraform plan
```

Review the plan before applying it. Creating the trigger enables builds and deployments when matching commits arrive.
