// Adding a repository, create triggers for cloud build, build the image, deploy to GKE cluster.
locals {
    image_repo_name = lower(var.cloud_source_repo_name)
}

resource "google_cloudbuild_trigger" "github_trigger" {
  name     = var.cloud_build_trigger_name
  project  = var.project_id
  
  trigger_template {
    branch_name = var.build_branch
    repo_name   = var.cloud_source_repo_name
  }

  substitutions = {
    _GKE_CLUSTER_NAME       = var.gke_cluster_name
    _REGION                 = var.region
    _DOCKERFILE_PATH        = var.dockerfile_path
    _K8S_MANIFESTS_DIRECTORY = var.k8s_manifests_directory
    _IMAGE_REPO_NAME        = local.image_repo_name
  }
  
  build {
    step {
        name = "gcr.io/cloud-builders/docker"
        args = ["build", "-t", "gcr.io/${var.project_id}/${local.image_repo_name}:latest", var.dockerfile_path]      
    }

    step {
        name = "gcr.io/cloud-builders/gcloud"
        args = [
        "container",
        "clusters",
        "get-credentials",
        var.gke_cluster_name,
        "--region",
        var.region,
        ]

        env = [
            "CLOUDSDK_COMPUTE_REGION=${var.region}",
            "CLOUDSDK_CONTAINER_CLUSTER=${var.gke_cluster_name}",
        ]
    }

    step {
        name = "gcr.io/cloud-builders/gke-deploy"
        args = ["apply", "--filename", var.k8s_manifests_directory, "--cluster", var.gke_cluster_name, "--location", var.region]
    }
  }
}