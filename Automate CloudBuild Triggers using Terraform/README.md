# Automate CloudBuild Triggers using Terraform

In this automation, the terraform script will automatically create a cloudbuild trigger with the defined configurations for the repository given and deploy it to GKE Cluster, defined in the terraform script.

NOTE: The project will create a trigger for repository given, but in case of Cloud Build Repository V1, it;s not possible to automactially connect with the Repository. It's one of the limitation of V1, and hence V2 was introduced enhancing API compatibility. 

FYI: The project is still in Development!!

## Required source-repository setup

This example uses Cloud Build's legacy `trigger_template` source configuration. Its `repo_name` field expects the **name of an existing Google Cloud Source Repositories repository** that Cloud Build can access, **not** a GitHub URL. A GitHub repository URL cannot be passed directly to `repo_name`.

Before applying, connect or mirror your source repository using a supported Cloud Build integration and provide its exact Cloud Source Repositories name as `cloud_source_repo_name` in the example `terraform.tfvars`. Set `build_branch` if the default `main` branch is not correct.

If your project uses **Cloud Build second-generation GitHub connections**, this legacy `trigger_template` example is not a drop-in solution: you must instead configure a Cloud Build v2 repository connection and use the appropriate `repository_event_config` trigger.

The service-account JSON path in the example is a placeholder. Never commit real credentials or Terraform state files. Confirm your connected repository, Artifact Registry or Container Registry permissions, GKE cluster, and deployment manifests before running `terraform apply`. This repository is a demonstration, not a fully provisioned end-to-end pipeline.
