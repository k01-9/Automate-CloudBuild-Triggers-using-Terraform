output "trigger_id" {
  description = "Cloud Build trigger ID for inspecting the trigger after apply."
  value       = google_cloudbuild_trigger.github_trigger.trigger_id
}

output "deployment_image_repository" {
  description = "Untagged image path used by the build and deployment steps."
  value       = local.image_repository
}
