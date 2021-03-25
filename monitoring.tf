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

module "notify_slack_uptimez" {
  count   = var.messaging_app == "slack" && var.messaging_critical_channel != "" ? 1 : 0

  source  = "terraform-aws-modules/notify-slack/aws"
  version = "4.13.0"

  sns_topic_name       = "${var.name}-uptimez"
  lambda_function_name = "${var.name}-uptimez"
  slack_webhook_url    = var.messaging_webhook
  slack_channel        = var.messaging_critical_channel
  slack_username       = "${var.name} uptime check"

  tags = local.tags
}

module "notify_slack_builds" {
  count   = var.messaging_app == "slack" && var.messaging_builds_channel != "" ? 1 : 0

  source  = "terraform-aws-modules/notify-slack/aws"
  version = "4.13.0"

  sns_topic_name       = "${var.name}-builds"
  lambda_function_name = "${var.name}-builds"
  slack_webhook_url    = var.messaging_webhook
  slack_channel        = var.messaging_builds_channel
  slack_username       = "${var.name} CI/CD"

  tags = local.tags
}

resource "aws_cloudwatch_event_target" "build_alerts" {
  count     = var.messaging_app == "slack" && var.messaging_builds_channel != "" ? 1 : 0

  target_id = "${var.name}-builds"
  rule      = aws_cloudwatch_event_rule.build_alerts[0].name
  arn       = module.notify_slack_builds[0].this_slack_topic_arn
}

resource "aws_cloudwatch_event_rule" "build_alerts" {
  count       = var.messaging_app == "slack" && var.messaging_builds_channel != "" ? 1 : 0

  name        = "capture-build-events"
  description = "Capture build events"

  tags = local.tags

  event_pattern = <<PATTERN
{
  "source": [
    "aws.codebuild"
  ],
  "detail-type": [
    "CodeBuild Build State Change"
  ],
  "detail": {
    "build-status": [
      "SUCCEEDED",
      "FAILED",
      "STOPPED"
    ]
  }
}
PATTERN
}

resource "aws_sns_topic_policy" "build_alerts" {
  count  = var.messaging_app == "slack" && var.messaging_builds_channel != "" ? 1 : 0

  arn    = module.notify_slack_builds[0].this_slack_topic_arn
  policy = data.aws_iam_policy_document.build_alerts_topic_policy[0].json
}

data "aws_iam_policy_document" "build_alerts_topic_policy" {
  count  = var.messaging_app == "slack" && var.messaging_builds_channel != "" ? 1 : 0

  statement {
    effect  = "Allow"
    actions = ["SNS:Publish"]

    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }

    resources = [ module.notify_slack_builds[0].this_slack_topic_arn ]
  }
}
