#!/bin/bash

# purpose: check that stora can access the internet
# version: 1.0

# ping Google's DNS server with 1 second timeout
ping 8.8.8.8 -c 1 -W 1 > /dev/null
