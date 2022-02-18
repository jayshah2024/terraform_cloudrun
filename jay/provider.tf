provider "google" {
  credentials = file("searce-msp-gcp-0c27439f1f0f.json")
  project = "searce-msp-gcp"
  region  = "us-central1"
  zone    = "us-central1-a"
}
