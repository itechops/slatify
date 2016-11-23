# slatify-webhook.sh
This script sendd simple message to slack. And it's able to ser message icon. Please run with --help to see usage information.

# Why?
You can send *semianonymous* message to Slack, or you can use it as external method to Slack team from your own script. 

# Installation
- copy script to any location on your unix based machine.
- ensure that script is executable

# Usage
This is simple script with arguments. Run script with `-H` or `--help` arguments to see help section. 

# Examples
Run script with *verbose* output
```{r, engine='bash', count_lines}
# ./slatify-webhook.sh -h https://hooks.slack.com/services/AAAAAAA/BBBBBBB/KKKKKKKKKKKKKKK -i apple -m "test apple ico" -v
INFO: Hook URL https://hooks.slack.com/services/AAAAAAA/BBBBBBB/KKKKKKKKKKKKKKK
INFO: ICON apple
INFO: Message "test apple ico"
INFO: Send status ok
```
Remove `-v` parameter for no output.

HINT!:  `-h HOOK` is mandatory parameter, but you can set default Hook url [here][3] and make hook argument optional :)

### Contacts and feenback
Feel free to [mail][2] me any feedback, suggestion or for collaboration

Cheers

[1]:https://api.slack.com/incoming-webhooks
[2]:mailto:slatify@itech.md?subject=Slatify
[3]:https://github.com/itechops/slatify/blob/dev/webhook/slatify-webhook.sh#L10

