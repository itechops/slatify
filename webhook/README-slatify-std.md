# slatify-std.sh
This script captures both, normal and error, outputs from another script execution. 
When all output is already captured (main script finished), `slatify_std.sh` sends output to [Slack][2]. But not all output. 

`slatify_std.sh` analyses STDOUT and STDERR separately. `slatify_std.sh` is looking for informative patterns in STDOUT and if find them, sends message to [Slack][2].
Current version is looking for `INFO`, `WARNING` and `ERROR` patterns. This is case sensitive, but feel free to change it, if you want. 
STDERR output is not analysed. It is error by default, so just send it to [Slack][2]

# Why?
[I][1] don't know. This is not realtime analyser, but it sends script execution summary. Analised normal output first, then error output. It looks good in slack.
This was scripted according to customer requirements.
Oh! the most impotant thing. This script ***doesn't create temporary files.*** 

# Installation
Just copy this script. It requires *bash* and nothing else

# Usage 
To capture stdout and stderr separately, we have to execute main script inside of `slatify-std.sh`. Just add `./slatify-std.sh` in front of your script, and you'll see result ini [Slack][2]. 
Don't worry about arguments. `slatify-std.sh` accepts any script arguments. 
Don't worry about main script language, `slatify-std.sh` acepts any scritps, which could be run from cli.
And sorry guys, all arguments are dedicated to main script.

# Examples
Simple job :
```bash
$> ./myjob.sh
```
Slatified job:
```bash
$> /path/to/slatify-std.sh ./myjob.sh
```

Simple PHP script:
```bash
$> php ./my_php_job.php
```
Slatified PHP script:
```bash
$> /path/to/slatify-std.sh php ./my_php_job.php
```
Simple script with arguments and sudo
```bash
$> sudo -H -u john bash -c /path_to_script/john_s_script.sh
```
Slatified ...:
```bash
$> /path/to/slatify-std.sh sudo -H -u john bash -c /path_to_script/john_s_script.sh
```

# For future.
I'm going to make it realtime. Soon..... Fell free to contact [me][1]. Any feedback is welcome

[1]:mailto:slatify@itech.md?subject=Slatify
[2]:https://slack.com


### Example
Simple script `all_errors.sh` actepts parametres, and prints all types of output:
```shell
# bash ./all_errors.sh "param one" "param two" "param three"
1.    this is simple output
2.    this is UNFORMATED error message in error output
3.    ERROR: INFO: this is INFO message in normal output
4.    ERROR: this is error message in normal output
5.    param three
6.    WARNING: this is warning message in normal output
7.    ERROR: this is error message in error output
```

Lines 1,3,4 and 6 were printed in simple ***STDOUT***.
Lines 2,5 and 7 were printed in ***STDERR***.

##### Just to check : 
Print normal output only:
```shell
#./all_errors.sh "param one" "param two" "param three" 2>/dev/null
1.    this is simple output
3.    ERROR: INFO: this is INFO message in normal output
4.    ERROR: this is error message in normal output
6.    WARNING: this is warning message in normal output
```

Print error level only:
```shell
#./all_errors.sh "param one" "param two" "param three" 2>&1 1>/dev/null
2.    this is UNFORMATED error message in error output
5.    param three
7.    ERROR: this is error message in error output
```

Let's analise output not only by error level but by content.

1.    this is simple output      `we don't need this in slack`
2.    this is UNFORMATED error message in error output `this is error, according to output level`
3.    ERROR: INFO: this is INFO message in normal output `this is error, because contains ERROR string`
4.    ERROR: this is error message in normal output s`same as previous`
5.    param three `this is error because of output level, check all_errors script for details`
6.    WARNING: this is warning message in normal output `this is warning message, by content`
7.    ERROR: this is error message in error output `this is *double* error, by output level and content`

##### Architecture concept
- all error level messages must be parsed as ERRORs
- normal output must be paesed by content, and find the most severe  state

##### HOW TO DO THIS ????
if you usually run script like `./all_errors.sh "param one" "param two" "param three"`, try to add *./check_output.sh* in front of, like `./check_output.sh ./all_errors.sh "param one" "param two" "param three"`

As result, your script will be executed, with all params (if applicable), and output will be splitted in NORMAL and ERROR outputs, analised per line and redirected to slack. 

Cheers 
