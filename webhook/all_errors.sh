#!/bin/bash

echo "this is simple output"
sleep 5
echo "this is UNFORMATED error message in error output" >&2
sleep 5
echo "INFO: this is INFO message in normal output"
sleep 5
echo -e "ERROR: this is error message in normal output"
sleep 5
echo "WARNING: this is warning message in normal output"
sleep 5
echo "ERROR: this is error message in error output" >&2

