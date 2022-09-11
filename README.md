# codefresh-tunnel-charts
Helm charts for Codefresh tunnel solution on top of frp. For ingressless operation of v2 runtimes


** Lifecycle **:
- Each PR creation/update (Pushes to source branch) will run CI that publishes to charmusem dev with version 0.0.0-{PR Source Branch}-{Commit Shot Sha} - for example 0.0.0-test-pr-250aeef
- When merged to main the version is bumped using gitversion (See https://gitversion.net/docs/reference/version-increments)
  Automatically minor version will be bumped. 
  * To bump Major version: Start merge commit message with +semver: major. IMPORTANT: The first Major version needs to be tagged manually. Until then GitVersion will only bump minotr version regardless of major semver commit message. See The above link for gitversion docs.
  * To bump patch/fix version: Start merge commit message with +semver: patch
