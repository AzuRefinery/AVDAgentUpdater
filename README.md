# AVD Agent Updater

Azure Virtual Desktop has a known limitation with the Host's ability to remain registered against the Hostpool.
If you have lot's of session hosts and the owners of these sessions hosts don't turn them on frequently - You will end up with machines that you cannot reach VIA the AVD remote desktop agent as described here:
https://learn.microsoft.com/en-us/azure/virtual-desktop/faq#how-often-should-i-turn-my-vms-on-to-prevent-registration-issues-

If you reach this point you will need to manually fix those unreachable VM's using the steps described here:
https://learn.microsoft.com/en-us/azure/virtual-desktop/troubleshoot-agent#your-issue-isnt-listed-here-or-wasnt-resolved

This is not fun :)
I wrote this very simple script to prevent this from happening and found that it works great and in the long term prevents session hosts from becoming unreachable.
It does a few very simple things:

1. Queries all Hostpools in the subscription
2. Retreives the agent version of each session host.
3. Saves the highest version it finds.
4. Turns on only the session hosts with an agent version lower than the highest one that was found

I found that these session hosts will usually auto update their AVD agent within a few minutes.

You will need a separate process to shut down the sessionhosts, I have these processes also ready and will share them here as well.
