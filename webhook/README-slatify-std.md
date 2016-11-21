# slatify-std.sh
This script captures both, normal and error, outputs from another script execution.
When all output is already captured (main script finished), `slatify_std.sh` sends output to [Slack][2]. But not all output. 

`slatify_std.sh` analyses STDOUT and STDERR separately. `slatify_std.sh` is looking for informative patterns in STDOUT and if find them, sends message to [Slack][2].
Current version is looking for `INFO`, `WARNING` and `ERROR` patterns. This is case sensitive, but feel free to change it, if you want. 
STDERR output is not analysed. It is error by default, so just send it to [Slack][2]

# Why?
[I][1] don't know. This is not realtime analyser, but it sends script execution summary. It analyses normal output first, then error output. It looks good in slack.
This was scripted according to customer requirements.
Oh! the most impotant thing. This script ***doesn't create temporary files.*** 

# Installation
Just copy this script. It requires *bash* and nothing else. Ah! *webhook URL*! Don't forget to get it from slack, and set into ***HOOK*** variable inside the script.

# Usage 
To capture stdout and stderr separately, we have to execute main script inside of `slatify-std.sh`. Just add `./slatify-std.sh` in front of your script, and you'll see result in [Slack][2]. 
Don't worry about arguments. `slatify-std.sh` accepts any script arguments. 
Don't worry about main script language, `slatify-std.sh` acepts any scritps, which could be run from cli.

# Examples
Simple job :
```{r, engine='bash', count_lines}
$> ./myjob.sh
```
Slatified job:
```{r, engine='bash', count_lines}
$> /path/to/slatify-std.sh ./myjob.sh
```

Simple PHP script:
```{r, engine='bash', count_lines}
$> php ./my_php_job.php
```
Slatified PHP script:
```{r, engine='bash', count_lines}
$> /path/to/slatify-std.sh php ./my_php_job.php
```
Simple script with arguments and sudo
```{r, engine='bash', count_lines}
$> sudo -H -u john bash -c /path_to_script/john_s_script.sh
```
Slatified ...:
```{r, engine='bash', count_lines}
$> /path/to/slatify-std.sh sudo -H -u john bash -c /path_to_script/john_s_script.sh
```

# For future.
I'm going to make it realtime. Soon..... Fell free to contact [me][1]. Any feedback is welcome

[1]:mailto:slatify@itech.md?subject=Slatify
[2]:https://slack.com
