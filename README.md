# Docker Image Mirror

simple bash script to copy often used docker images to our registry to prevent a single point of failure ;)

## Installation

You can easily install the Script with `make`

    git clone https://github.com/0x46616c6b/docker-image-mirror.git
    cd docker-image-mirror
    make install
    docker-image-mirror -h

## Usage

    # mirror multiple images
    docker-image-mirror -r yourregistry.com -i "ubuntu redis"

    # only one tag
    docker-image-mirror -r yourregistry.com -i "redis" -t 3
