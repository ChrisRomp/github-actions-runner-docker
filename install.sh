#!/bin/bash
cd /home/docker/actions-runner

# resolve latest version of the runner
latest_version_label=$(curl -s -X GET 'https://api.github.com/repos/actions/runner/releases/latest' | jq -r '.tag_name')

latest_version=$(echo ${latest_version_label:1})
echo "Latest version: $latest_version"

runner_file="actions-runner-${RUNNER_PLATFORM}-x64-${latest_version}.tar.gz"

# download the latest version of the runner
if [ -f "${runner_file}" ]; then
    echo "${runner_file} exists. skipping download."
else
    runner_url="https://github.com/actions/runner/releases/download/${latest_version_label}/${runner_file}"
    echo "Downloading: ${runner_url}"
    curl -O -L $runner_url

    # extract the runner
    tar xzf ./actions-runner-${RUNNER_PLATFORM}-x64-${latest_version}.tar.gz

    # cleanup
    rm ./*.tar.gz
fi
