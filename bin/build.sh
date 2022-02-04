#!/bin/bash

package_name=steve
platforms=("darwin/amd64" "darwin/arm64" "linux/amd64" "windows/amd64")
output_dir=release

cd ../src/steve
mkdir $output_dir

for platform in "${platforms[@]}"
do
  platform_split=(${platform//\// })
  GOOS=${platform_split[0]}
  GOARCH=${platform_split[1]}

  bin_name=$package_name
  output_name="${bin_name}-${GOOS}-${GOARCH}.tar.gz"

  if [ $GOOS = "windows" ]; then
    bin_name+=".exe"
  fi

  env GOOS=$GOOS GOARCH=$GOARCH go build -o $bin_name $package
  tar -czf "${output_dir}/${output_name}" $bin_name
  sha512sum "${output_dir}/${output_name}" > "${output_dir}/${output_name}.sha512sum"
done
