mock_provider "google" {}

variables {
  project_id       = "example-project"
  github_repo_url  = "https://github.com/example/example-app.git"
  gke_cluster_name = "example-cluster"
  sa_token         = null
}

run "default_trigger" {
  command = plan

  assert {
    condition     = !google_cloudbuild_trigger.github_trigger.disabled && google_cloudbuild_trigger.github_trigger.build[0].timeout == "3600s"
    error_message = "The default trigger should be enabled with a one-hour build timeout."
  }

  assert {
    condition     = output.deployment_image_repository == "gcr.io/example-project/example-app"
    error_message = "The default image path should use the GitHub repository slug."
  }
}

run "custom_trigger" {
  command = plan

  variables {
    trigger_disabled      = true
    build_timeout_seconds = 900
    image_repository      = "us-central1-docker.pkg.dev/example-project/images/example-app"
    gke_cluster_location  = "us-central1-a"
    included_files        = ["app/**"]
  }

  assert {
    condition     = google_cloudbuild_trigger.github_trigger.disabled && google_cloudbuild_trigger.github_trigger.build[0].timeout == "900s"
    error_message = "The plan should preserve the requested disabled state and timeout."
  }

  assert {
    condition     = contains(google_cloudbuild_trigger.github_trigger.build[0].step[2].args, "us-central1-a") && output.deployment_image_repository == var.image_repository
    error_message = "The plan should use the configured GKE zone and standalone image path."
  }
}
