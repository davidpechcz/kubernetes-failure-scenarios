<br />

Kyverno webhooks should run in multiple replicas:
https://kyverno.io/docs/installation/methods/#high-availability-installation

And depending if we prefer availability (possibly skip validation and mutation) or security, we can tweak this know:
https://kyverno.io/docs/installation/customization/#container-flags
`forceFailurePolicyIgnore`
which will just skip webhook, if it's not available.

Also - there is the switch: `autoUpdateWebhooks` - this will instruct Kyverno to dynamically change webhook configurations based on the real policies (and their filter) that we have. So only the resources that really require validation/mutation are processed via webhook, nothing else. This significantly lowers the blast radius typically.
https://kubernetes.io/docs/concepts/cluster-administration/admission-webhooks-good-practices/

<br />