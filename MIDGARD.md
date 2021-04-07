# Midgard TypeScript fork

The Midgard fork of TypeScript is maintained in the `midgard` branch.
For every new release of TypeScript, the changes are rebased on top of the
new release and pushed to the `midgard` branch.

For each version of TypeScript, a release branch is created in the form `releases/vX.X.X-midgard`
on top of which patches can be made.

Any new changes should be merged with the `midgard` branch.
They will be applied when the next version of the upstream TypeScript is released.

With each new release of TypeScript, or a patch has been applied,
a tag is created in the form `vX.X.X-midgard` which is published
to npm [here](https://www.npmjs.com/package/@msfast/typescript-platform-resolution)

## Maintenance

The automated workflows for this are the [workflows with the `midgard-` prefix](.github/workflows)
