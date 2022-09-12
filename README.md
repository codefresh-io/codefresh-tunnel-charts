<center><h1><u>Codefresh-tunnel-charts</u></h1>
Helm charts for Codefresh tunnel solution on top of frp. For ingressless operation of v2 runtimes 
</center>


###
<b>Lifecycle notes:</b>
<p>
Each PR creation/update (Pushes to source branch) will run CI that publishes to charmusem dev with version 0.0.0-{PR Source Branch}-{Commit Shot Sha} - for example 0.0.0-test-pr-250aeef
</p>
<p>
 When merged to main the version is bumped automatically using gitversion by reading the <b>commit message</b> (See https://gitversion.net/docs/reference/version-increments): <br><br>
  By default minor version will be bumped. <br>
  * To bump Major version: Start merge commit message with +semver: major. <br> <b>IMPORTANT:</b> The first Major version needs to be tagged manually. Until then GitVersion will only bump minor version regardless of major semver commit message. See The above link for gitversion docs. <br>
  * To bump patch/fix: Start merge commit message with +semver: patch
</p>