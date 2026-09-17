# flaws.cloud — free hosted AWS CTF (start here)

[flaws.cloud](http://flaws.cloud) and [flaws2.cloud](http://flaws2.cloud) are free,
browser-based AWS security games by Scott Piper. **Nothing to install, no account, no cost** —
just the AWS CLI (optional) and a browser. Do these before the local modules.

## What they teach (no spoilers — approach only)
- **flaws.cloud** — S3 bucket misconfiguration and enumeration, public objects, reading bucket
  contents anonymously, IAM/permissions leakage, and how one weak link chains to the next.
- **flaws2.cloud** — both an **Attacker** and a **Defender** track: container/metadata SSRF,
  stealing instance-role credentials via the **instance metadata service (169.254.169.254)**,
  and then the defensive side of locking it down.

## Setup (optional CLI)
```bash
# macOS
brew install awscli
aws configure   # you can use throwaway/anonymous access for many steps
# many flaws.cloud steps work with:  aws s3 ls s3://<bucket> --no-sign-request
```

## How to work them
1. Try each level yourself first; note what you enumerate and why.
2. Record findings in your own notes (great portfolio material).
3. Only then read the official hints on the site.

## The takeaways to internalize
- Public S3 + predictable names = data exposure.
- Instance metadata → temporary credentials is the classic cloud SSRF pivot.
- Least privilege and blocking public access would have stopped most of it — which is exactly
  what you practice fixing in Module 1 and catch automatically in Module 2.
