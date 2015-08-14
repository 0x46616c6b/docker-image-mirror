# Docker Image Mirror

simple bash script to copy often used docker images to our registry to prevent a single point of failure ;)

## Usage

    git clone https://github.com/0x46616c6b/docker-image-mirror.git
    cd docker-image-mirror

    ./mirror.sh -r example.com -i "ubuntu redis"
