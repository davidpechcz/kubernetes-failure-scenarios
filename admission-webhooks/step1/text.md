<br />

It's basically a chicken-egg problem that we run a Pod serving a admission webhook inside the same cluster. So if the Pod serving the webhook gets broken AND at the same time the policies have `failurePolicy: Fail` - depending on the webhook filters, the cluster might be completely broken.

Kyverno can do exactly this:
- webhooks are applied to almost every resource in the cluster
- failure policy is to Fail, so no resource can pass the validation without a check


How to fix this:
- we need to get webhook Pod up-and-running
- Pod operations fails, because it's not able to contact the webhook that is being configured via `MutatingWebhookConfiguration` and `ValidatingWebhookConfiguration`.
- (Kyverno add these configuration when the Pod starts and reapplies them if they are not present - so it is safe to remove them, let a Pod start and create them later on)
- However by this, we can for example let other Pods possibly bypass validation/mutation for a brief period of time - so in theory (not in an incident) - just excluding Kyverno namespace from webhook configurations might be a safer approach.


```plain
kubectl get MutatingWebhookConfiguration
```{{exec}}

Delete all Kyverno-related:
```plain
kubectl delete MutatingWebhookConfiguration kyverno-policy-mutating-webhook-cfg kyverno-resource-mutating-webhook-cfg kyverno-verify-mutating-webhook-cfg
```{{exec}}

```plain
kubectl get ValidatingWebhookConfiguration
```{{exec}}

Delete all Kyverno-related:
```plain
kubectl delete ValidatingWebhookConfiguration kyverno-exception-validating-webhook-cfg kyverno-global-context-validating-webhook-cfg kyverno-policy-validating-webhook-cfg kyverno-resource-validating-webhook-cfg
```{{exec}}

Scale back `kyverno` Deployment
```plain
kubectl scale deployment kyverno-admission-controller -n kyverno --replicas=1
```{{exec}}

Wait a bit...

Pods should be able to start now:
```plain
kubectl get events -A
```{{exec}}

And after a while - the Kyverno should recreate webhooks configurations:
```plain
kubectl get MutatingWebhookConfiguration
kubectl get ValidatingWebhookConfiguration
```{{exec}}


Let's discuss what we can do to make our cluster more resiliant.

<br />