terraform {
  required_version = ">= 1.3"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.0"
    }
  }
}

// Provider

provider "google" {
  credentials = var.sa_token == null ? null : file(pathexpand(var.sa_token))
  project     = var.project_id
  region      = var.region
}