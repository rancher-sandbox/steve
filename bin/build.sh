#!/bin/bash

package_name=steve
platforms=("darwin/amd64" "darwin/arm64" "linux/amd64" "windows/amd64")

pushd ../src/steve

for platform in "${platforms[@]}"
do
  platform_split=(${platform//\// })
  GOOS=${platform_split[0]}
  GOARCH=${platform_split[1]}

  output_name=$package_name
  compressed_name="${output_name}-${GOOS}-${GOARCH}.tar.gz"

  if [ $GOOS = "windows" ]; then
    output_name+=".exe"
  fi

  env GOOS=$GOOS GOARCH=$GOARCH go build -o $output_name $package
  tar -czvf $compressed_name $output_name
done
