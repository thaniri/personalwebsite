#!/usr/bin/env bash
# Build the site with Hugo and upload it to the www.thaniri.ca S3 bucket,
# then invalidate the CloudFront cache so the new content is served.
#
# Usage: hack/deploy.sh [--dry-run]
#
# Runs inside the Nix dev shell (re-executing itself via `nix develop` if
# hugo or aws are not on PATH). AWS credentials come from the usual AWS CLI
# sources, e.g. AWS_PROFILE set in .envrc.local.
#
# Overridable with environment variables:
#   BUCKET      S3 bucket to upload to        (default: www.thaniri.ca)
#   REGION      region of the bucket          (default: ca-central-1)
#   STACK_NAME  website CloudFormation stack  (default: thaniriS3wesbite)
set -euo pipefail

BUCKET="${BUCKET:-www.thaniri.ca}"
REGION="${REGION:-ca-central-1}"
STACK_NAME="${STACK_NAME:-thaniriS3wesbite}"

dry_run=false
case "${1:-}" in
  "") ;;
  --dry-run) dry_run=true ;;
  *) echo "Usage: $0 [--dry-run]" >&2; exit 2 ;;
esac

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$repo_root"

if ! command -v hugo >/dev/null || ! command -v aws >/dev/null; then
  echo "==> hugo or aws not found, re-running inside the Nix dev shell"
  exec nix develop "$repo_root" --command "$repo_root/hack/deploy.sh" "$@"
fi

echo "==> Checking AWS credentials"
aws sts get-caller-identity --query Arn --output text

echo "==> Building site with $(hugo version | cut -d' ' -f1-2)"
hugo --cleanDestinationDir

sync_args=(--delete --region "$REGION")
if "$dry_run"; then
  sync_args+=(--dryrun)
fi

echo "==> Uploading public/ to s3://$BUCKET"
aws s3 sync public/ "s3://$BUCKET" "${sync_args[@]}"

if "$dry_run"; then
  echo "==> Dry run: skipping CloudFront invalidation"
  exit 0
fi

echo "==> Invalidating CloudFront cache"
distribution_id="$(aws cloudformation describe-stack-resource \
  --stack-name "$STACK_NAME" \
  --logical-resource-id CDNDistribution \
  --region "$REGION" \
  --query StackResourceDetail.PhysicalResourceId \
  --output text)"
aws cloudfront create-invalidation \
  --distribution-id "$distribution_id" \
  --paths '/*' \
  --query Invalidation.Id \
  --output text

echo "==> Deployed to https://${BUCKET#www.}/"
