terraform {
  backend "remote"{
    organization = "huy-terraform"

    workspaces {
        name = "huy-dev"
    }
  }
}
