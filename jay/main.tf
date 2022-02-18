

// Ressource 1: cloud run service running the docker image
// Write the path to the docker image hosted in the google container registry
// To set up this resource with Terraform, the service account key used 
// must have the appropriate permissions.


resource "google_cloud_run_service" "service" {

  for_each = var.cloudrun_services
  name     = each.key

  location = each.value.location

   template {
    spec {
      containers {
        image = each.value.image
      resources {
        limits = {
          cpu = each.value.cpu
          memory = each.value.memory
        }
      }
    }
  }
    metadata {
        annotations = {
                "autoscaling.knative.dev/minScale" = each.value.min_instances,
                "autoscaling.knative.dev/maxScale" = each.value.max_instances
             }
      }  
  }
  
  traffic {
    percent         = 100
    latest_revision = true
  }
  metadata {
	annotations = {
		"run.googleapis.com/launch-stage" =  "BETA"
		}
	}
}


// Ressource 2: gives to non authenticated users access to the web page
// To set up this resource with Terraform, the service account key used 
// must have the appropriate permissions.

data "google_iam_policy" "noauth" {
  binding {
    role = "roles/run.invoker"
    members = ["allUsers"]
  }
}



resource "google_cloud_run_service_iam_policy" "noauth" {
  for_each    =    var.cloudrun_services
  
  service     = google_cloud_run_service.service[each.key].name
  location    = google_cloud_run_service.service[each.key].location
  policy_data = data.google_iam_policy.noauth.policy_data
}
