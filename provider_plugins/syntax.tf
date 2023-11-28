terraform {
  required_providers {
    NAME = {
      source  = "SOURCE_ADDRESS"
      version = "VERSION_CONSTRAINT"
    }
  }
}

provider "NAME" {
  # Provider specific arguments
}

provider "NAME" {
  alias = "ALIAS_NAME"
  # Provider specific arguments
}

resource "NAME_TYPE" "name" {
  
}
