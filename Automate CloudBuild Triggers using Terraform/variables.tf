variable "project_id" {
  description = "Your GCP Project ID"
}

variable "sa_token" {
    description = "Your ServiceAccount File Path"
}

variable "region" {
  description = "GCP region where resources will be created"
  default     = "us-central1"
}

variable "gke_cluster_name" {
  description = "Name of your existing GKE cluster"
}

variable "cloud_source_repo_name" {
  description = "Exact name of an existing Cloud Source Repositories repo connected to Cloud Build (not a GitHub URL)"
  type        = string
  validation {
    condition     = length(trimspace(var.cloud_source_repo_name)) > 0 && !strcontains(var.cloud_source_repo_name, "/")
    error_message = "Specify a Cloud Source Repositories repository name, not a URL or path."
  }
}

variable "build_branch" {
  description = "Git branch to build from the connected source repository"
  type        = string
  default     = "main"
}

variable "cloud_build_trigger_name" {
  description = "Name for the Cloud Build trigger"
  default     = "github-trigger"
}

variable "dockerfile_path" {
  description = "Path to the Dockerfile in the GitHub repository"
  default     = "./"
}

variable "k8s_manifests_directory" {
  description = "Path to the Kubernetes manifests directory"
  default     = "/kubernetes/prod"
}

