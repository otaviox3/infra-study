# GitHub SSH (Port 443)

This VM cannot access GitHub over SSH port 22, so I configured SSH over port 443.

## Test
ssh -T git@github.com

Expected:
Hi <user>! You've successfully authenticated...
