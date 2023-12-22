# FoundryVTT containerized docker compose example

## Obtaining the TIMED DOWNLOAD URL

1. Make sure you have purchased a valid FoundryVTT license at https://foundryvtt.com/purchase/.
2. Log into your FoundryVTT.com account.
3. Visit https://foundryvtt.com/me/licenses.
4. On this page, set "Operating System" to "Linux/NodeJS"
5. Click the "TIMED URL" button. This copies a timed download URL to your clipoard.
6. Paste this URL as environment variable `FOUNDRYVTT_DOWNLOAD_URL` and start your container (see examples below)

![FoundryVTT Download Page](../docs/download-page.png "FoundryVTT Download Page")

## Configuring the TIMED DOWNLOAD URL

Edit  [.env](./.env) and set your timed download URL for FoundryVTT.

## Starting FoundryVTT containerized

To start FoundryVTT containerized, run

```
docker compose up -d
```

Visit http://localhost:8080/ to confirm the FoundryVTT Terms of Service and enter your license key.