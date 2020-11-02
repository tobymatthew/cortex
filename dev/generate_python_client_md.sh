#!/bin/bash

# Copyright 2020 Cortex Labs, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.


set -euo pipefail

if [[ "$OSTYPE" != "linux"* ]]; then
  echo "error: this script is only designed to run on linux"
  exit 1
fi

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")"/.. >/dev/null && pwd)"

pip3 uninstall -y cortex

cd $ROOT/pkg/workloads/cortex/client

pip3 install -e .

pydoc-markdown -m cortex -m cortex.client --render-toc > $ROOT/docs/miscellaneous/python_client.md

# title
sed -i "s/# Table of Contents/# Python client/g" $ROOT/docs/miscellaneous/python_client.md

# delete links
sed -i "/<a name=/d" $ROOT/docs/miscellaneous/python_client.md

# delete unnecessary section headers
sed -i "/_](#cortex\.client\.Client\.__init__)/d" $ROOT/docs/miscellaneous/python_client.md
sed -i "/\* \[Client](#cortex\.client\.Client)/d" $ROOT/docs/miscellaneous/python_client.md
# fix section link/header
sed -i "s/\* \[cortex\.client](#cortex\.client)/\* [cortex\.client\.Client](#cortex-client-client)/g" $ROOT/docs/miscellaneous/python_client.md
sed -i "s/# cortex\.client/# cortex\.client\.Client/g" $ROOT/docs/miscellaneous/python_client.md
# delete unnecessary section body
sed -i "/# cortex.client.Client/,/## deploy/{//!d}" $ROOT/docs/miscellaneous/python_client.md
sed -i "s/# cortex.client.Client/# cortex.client.Client\n/g" $ROOT/docs/miscellaneous/python_client.md

# fix table of contents links
sed -i "s/](#cortex\./](#/g" $ROOT/docs/miscellaneous/python_client.md
sed -i "s/](#client\.Client\./](#/g" $ROOT/docs/miscellaneous/python_client.md

# indentdation
sed -i "s/    \* /  \* /g" $ROOT/docs/miscellaneous/python_client.md
sed -i "s/#### /## /g" $ROOT/docs/miscellaneous/python_client.md

# whitespace
sed -i 's/[[:space:]]*$//' $ROOT/docs/miscellaneous/python_client.md
truncate -s -1 $ROOT/docs/miscellaneous/python_client.md

pip3 uninstall -y cortex

cat << EOF

#### MANUAL EDITS REQUIRED ####

- Update the `client(env: str)` docstring in the generated docs (copy-paste it in and unindent)

Then check the diff
EOF

# TODO automate? test on mac?