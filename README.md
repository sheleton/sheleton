# Sheleton

Sheleton is a Bash skeleton (S[h|k]eleton).

## Usage

In your application directory:

    mkdir vendor bin etc
    git clone https://git.fastnet.ch/vl/sheleton.git vendor/sheleton
    touch etc/hello
    chmod +x etc/hello

Sample application in docs/core.md.

## Development Environment

Build container:

    docker build -t sheleton .

Run interactif container:

    docker run -it --rm -v $(pwd):/root/sheleton sheleton /bin/bash

Running tests (inside the container):

    bats tests/*.bats
