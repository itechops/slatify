
# Slatify webhook
bash scripts, to send messages to slack via webhook

- slatify-webhook.sh - send simple message to slack. Please run with --help to see usage information, or read small [description][5].
- slatify-std.sh - captures both, STDOUT and STDERR, then sends notification to Slack. Please find [details here][4].

### Install
- Add [webhook integration][1] to your slack and configure it. Find *Webhook URL* in configuration and save it. It will be used for sending message to right place. 
- copy script(s) to any location on your unix based machine. 
- ensure that script is executable 

### Usage
Most scripts have help section. Anyway, you can read short desctiption in the top of this page, or detailed descriptions in separate readme files.

### Examples
Run script with *verbose* output 
```{r, engine='bash', count_lines}
# ./slatify-webhook.sh -h https://hooks.slack.com/services/AAAAAAA/BBBBBBB/KKKKKKKKKKKKKKK -i apple -m "test apple ico" -v
INFO: Hook URL https://hooks.slack.com/services/AAAAAAA/BBBBBBB/KKKKKKKKKKKKKKK
INFO: ICON apple
INFO: Message "test apple ico"
INFO: Send status ok
```
Remove `-v` parameter for no output. 

HINT!:  `-h HOOK` is mandatory parameter, but you can set default Hook url [here][3] and omit it for default hook :)

### Contacts and feenback 
Feel free to [mail][2] me any feedback, suggestion or for collaboration 

Cheers

[1]:https://api.slack.com/incoming-webhooks
[2]:mailto:slatify@itech.md?subject=Slatify
[3]:https://github.com/itechops/slatify/blob/dev/webhook/slatify-webhook.sh#L10
[4]:https://github.com/itechops/slatify/blob/master/webhook/README-slatify-std.md
[4]:https://github.com/itechops/slatify/blob/master/webhook/README-slatify-webhook.md

