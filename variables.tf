/**
 * Copyright 2021 Taito United
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

variable "tags" {
  type = map(string)
  default = {}
  description = "A mapping of tags to assign to all resources."
}

variable "name" {
  type = string
  description = "Unique name used as a prefix for all resources to avoid name conflicts within the AWS account."
}

variable "messaging_app" {
  type = string
  default = ""
  description = "Supported values: slack"
}

variable "messaging_webhook" {
  type = string
  default = ""
  description = "For example: slack webhook url"
}

variable "messaging_critical_channel" {
  type = string
  default = ""
  description = "For example: critical slack channel"
}

variable "messaging_builds_channel" {
  type = string
  default = ""
  description = "For example: builds slack channel"
}

/* TODO: implement alerts (use google module as an example)
variable "alerts" {
  type = list(object({
    name = string
    type = string
    channels = list(string)
    rule = string
  }))
  description = "Resources as JSON (see README.md). You can read values from a YAML file with yamldecode()."
}
*/
