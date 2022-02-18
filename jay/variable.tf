variable "cloudrun_services" {
  description = "Create CR instances with these name and parameters"
  default = {
    service-1 = {
      image = "gcr.io/searce-msp-gcp/helloworld:latest"
      location = "asia-south1"
      cpu = "2.0"
      memory = "8000Mi"
      min_instances = "2"
      max_instances = "200"

    }

    service-2 = {
      image = "gcr.io/searce-msp-gcp/hello-app:v1"
      location = "asia-south1"
      cpu = "2.0"
      memory = "5000Mi"
      min_instances = "2"
      max_instances = "200"
    }
  }
}
