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

variable "image_repository" {
  description = "Untagged destination image path, including the registry hostname"
  type        = string
  default     = null

  validation {
    condition     = var.image_repository == null ? true : can(regex("^[a-z0-9.-]+(/[a-z0-9._-]+)+$", var.image_repository))
    error_message = "image_repository must be an untagged image path such as us-central1-docker.pkg.dev/project/repository/app."
  }
}

variable "gke_cluster_location" {
  description = "Region or zone of the target GKE cluster; defaults to the provider region"
  type        = string
  default     = null
}

variable "included_files" {
  description = "Repository-relative path globs that can start a build; empty allows all paths"
  type        = list(string)
  default     = []
}

variable "ignored_files" {
  description = "Repository-relative path globs excluded from trigger matching"
  type        = list(string)
  default     = []
}

variable "trigger_disabled" {
  description = "Create or keep the trigger disabled so repository pushes do not start builds"
  type        = bool
  default     = false
}

variable "build_timeout_seconds" {
  description = "Maximum duration of a triggered build in seconds"
  type        = number
  default     = 3600

  validation {
    condition     = var.build_timeout_seconds >= 1 && var.build_timeout_seconds <= 86400 && floor(var.build_timeout_seconds) == var.build_timeout_seconds
    error_message = "build_timeout_seconds must be a whole number from 1 to 86400."
  }
}
