#!/usr/bin/env nix-shell
#!nix-shell -i bash -p bash wget coreutils nix
version=$1

if [[ -z $version ]]
then
    echo "Pass the version to get hashes for as an argument"
    exit 1
fi

allOutput=""

dlDest=$(mktemp)

trap 'rm $dlDest' EXIT

for plat in osx linux; do
    for arch in x64 arm64; do

        URL="https://github.com/PowerShell/PowerShell/releases/download/v$version/powershell-$version-$plat-$arch.tar.gz"
        wget $URL -O $dlDest >&2

        hash=$(nix hash file $dlDest)

        allOutput+="
variant: $plat $arch
hash: $hash
"

    done
done

echo "$allOutput"
