#!/bin/bash
set -e

./apply.sh website -auto-approve
./test.sh
