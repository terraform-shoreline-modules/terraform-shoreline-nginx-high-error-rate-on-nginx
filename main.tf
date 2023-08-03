terraform {
  required_version = ">= 0.13.1"

  required_providers {
    shoreline = {
      source  = "shorelinesoftware/shoreline"
      version = ">= 1.11.0"
    }
  }
}

provider "shoreline" {
  retries = 2
  debug = true
}

module "high_error_rate_on_nginx_incident" {
  source    = "./modules/high_error_rate_on_nginx_incident"

  providers = {
    shoreline = shoreline
  }
}