# FoundryVTT containerized Kubernetes compose example

The recommended way of using FoundryVTT containerized on Kubernetes is to use the Helm chart at https://github.com/pgschk/helm-charts/tree/main/charts/foundryvtt-containerized

If you want to set it up manually, follow these steps.

## Obtaining the TIMED DOWNLOAD URL

1. Make sure you have purchased a valid FoundryVTT license at https://foundryvtt.com/purchase/.
2. Log into your FoundryVTT.com account.
3. Visit https://foundryvtt.com/me/licenses.
4. On this page, set "Operating System" to "Linux/NodeJS"
5. Click the "TIMED URL" button. This copies a timed download URL to your clipoard.
6. Paste this URL as environment variable `FOUNDRYVTT_DOWNLOAD_URL` and start your container (see examples below)

![FoundryVTT Download Page](../docs/download-page.png "FoundryVTT Download Page")

## Configuring the TIMED DOWNLOAD URL and customizing the deployment

- Review and adapt the example in [deployment.yaml](./deployment.yaml).
- Make sure to set your timed download URL for FoundryVTT as enviroment variable `FOUNDRYVTT_DOWNLOAD_URL`.


## Applying the deployment

Once you customized the deployment and configured your TIMED DOWNLOAD URL, you cann apply the file to your Kubernetes installation:

```
kubectl apply -n <target namespace> -f deployment.yaml
```

