#!/bin/bash

##--Make md5 list
find src -type f -exec md5sum {} \;> checksums_src.md5
