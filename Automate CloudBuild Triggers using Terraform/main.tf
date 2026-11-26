// Adding a repository, create triggers for cloud build, build the image, deploy to GKE cluster.
locals {
  image_repository = coalesce(var.image_repository, "gcr.io/${var.project_id}/${local.github_repo_name}")
  image            = "${local.image_repository}:$BUILD_ID"
  github_repo_name = trimsuffix(lower(basename(trimsuffix(trimspace(var.github_repo_url), "/"))), ".git")
}

resource "google_cloudbuild_trigger" "github_trigger" {
  name    = var.cloud_build_trigger_name
  project = var.project_id

  trigger_template {
    branch_name = var.branch_pattern
    repo_name   = coalesce(var.cloud_build_repository_name, local.github_repo_name)
  }

  build {
    step {
      name = "gcr.io/cloud-builders/docker"
      args = ["build", "-f", var.dockerfile_path, "-t", local.image, var.build_context]
    }

    step {
      name = "gcr.io/cloud-builders/docker"
      args = ["push", local.image]
    }

    step {
      name = "gcr.io/cloud-builders/gke-deploy"
      args = [
        "run",
        "--filename", var.k8s_manifests_directory,
        "--image", local.image,
        "--cluster", var.gke_cluster_name,
        "--location", coalesce(var.gke_cluster_location, var.region),
      ]
    }
  }
}
