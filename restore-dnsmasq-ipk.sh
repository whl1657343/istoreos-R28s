#!/bin/sh
set -eu

package_file=/home/toor/r28s/bin/packages/aarch64_generic/base/dnsmasq_2.93-r2_aarch64_generic.ipk
work_dir=$(mktemp -d)
trap 'rm -rf "$work_dir"' EXIT

( cd "$work_dir" && ar x "$package_file" )
( cd "$work_dir" && tar --format=gnu --numeric-owner --sort=name -cf - \
	--mtime="@0" ./debian-binary ./data.tar.gz ./control.tar.gz | gzip -n - > "$package_file" )
