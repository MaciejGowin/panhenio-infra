# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

Deploy an individual stack:
```sh
make cicd-deploy      # CI/CD artifacts bucket
make data-deploy      # DynamoDB tables
make email-deploy     # SES email identity
make website-deploy   # S3 buckets for website and admin
make gateway-deploy   # API Gateway + CloudFront distributions
make deploy           # all stacks in order
```

All commands call `aws cloudformation deploy` with parameters `PROJECT=PANHENIO`, `ENVIRONMENT=PROD`, `DOMAIN_NAME=panhenio.pl`.

## Architecture

Five CloudFormation stacks for **panhenio.pl** (Polish event management platform):

| Stack | File | Purpose |
|---|---|---|
| CICD | `cicd.yaml` | S3 bucket for build artifacts (`panhenio-cicd-prod`) |
| Data | `data.yaml` | DynamoDB tables for events and configuration |
| Email | `email.yaml` | SES tenant and email identity for `panhenio.pl` |
| Website | `website.yaml` | Private S3 buckets for main site and admin dashboard |
| Gateway | `gateway.yaml` | API Gateway (HTTP) + CloudFront distributions |

### Cross-stack dependencies

`gateway.yaml` imports S3 regional URLs from `website.yaml` via CloudFormation exports:
- `PANHENIO-PROD::S3::Website::RegionalURL`
- `PANHENIO-PROD::S3::AdminWebsite::RegionalURL`

Deploy order: website → gateway (data, email, cicd are independent).

### Data layer

Two DynamoDB tables (pay-per-request):
- `PANHENIO-ORGANIZER-EVENT-BUNDLE-PROD` — event bundles keyed by `organizerId` + `month`, with GSI `monthIndex` for month-based queries
- `PANHENIO-CONFIGURATION-PROD` — key-value configuration keyed by `id`

### CDN / routing

Two CloudFront distributions, each backed by an S3 origin and an HTTP API Gateway origin:
- **Main** (panhenio.pl, www.panhenio.pl) — caches Next.js static files (`/_next/static/*`) and images aggressively; API routes bypass cache
- **Admin** (admin.panhenio.pl) — separate S3 origin for the admin dashboard SPA

Both use Origin Access Control (OAC); S3 buckets block all direct public access. TLS certificates are hardcoded ACM ARNs in `gateway.yaml`.
