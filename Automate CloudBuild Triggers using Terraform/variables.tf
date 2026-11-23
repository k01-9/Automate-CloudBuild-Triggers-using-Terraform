variable "project_id" {
  description = "Your GCP Project ID"
}

variable "sa_token" {
  description = "Optional service account JSON file path; omit to use Application Default Credentials"
  type        = string
  default     = null
}

variable "region" {
  description = "GCP region where resources will be created"
  default     = "us-central1"
}

variable "gke_cluster_name" {
  description = "Name of your existing GKE cluster"
}

variable "github_repo_url" {
  description = "URL of your GitHub repository"
}

variable "cloud_build_trigger_name" {
  description = "Name for the Cloud Build trigger"
  default     = "github-trigger"
}

variable "dockerfile_path" {
  description = "Path to the Dockerfile in the GitHub repository"
  default     = "Dockerfile"
}

variable "build_context" {
  description = "Docker build context relative to the checked-out repository"
  type        = string
  default     = "."
}

variable "k8s_manifests_directory" {
  description = "Path to the Kubernetes manifests directory"
  default     = "kubernetes/prod"
}

variable "cloud_build_repository_name" {
  description = "Name of the repository already connected to Cloud Build (defaults to the GitHub repository slug)"
  type        = string
  default     = null
}

variable "branch_pattern" {
  description = "Regular expression matching branches that should start a build"
  type        = string
  default     = "^main$"

  validation {
    condition     = can(regexall(var.branch_pattern, ""))
    error_message = "branch_pattern must be a valid regular expression."
  }
}
