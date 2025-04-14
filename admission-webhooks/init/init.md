<br />

This cluster is broken. Fix it!

This app seems ok:
```plain
kubectl get pod -n app-white
```{{exec}}

This seems broken (it's being changed every 20s in the background):
```plain
kubectl get pod -n app-black
```{{exec}}

And maybe you have even larger problems:
```plain
kubectl run --image=nginx -n default myapp
```{{exec}}

All the events can be visible here:
```plain
kubectl get events -A
```{{exec}}

```plain
kubectl get events -A -o yaml | less
```{{exec}}

Even `k9s` fails:
```plain
k9s
```{{exec}}


The problem is in the admission webhooks:
[docs](https://kubernetes.io/docs/reference/access-authn-authz/admission-controllers/).

Either fix it yourself (so the `app-black` works correctly), or check the next page with a solution.

<br />