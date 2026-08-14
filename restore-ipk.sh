#!/bin/sh
set -eu

package_dir=/home/toor/r28s/bin/targets/rockchip/armv8/packages
work_root=$(mktemp -d)
trap 'rm -rf "$work_root"' EXIT

for package_file in "$package_dir"/*.ipk; do
	[ -f "$package_file" ] || continue
	work_dir="$work_root/${package_file##*/}"
	mkdir "$work_dir"
	ar -xf "$package_file" -C "$work_dir"
	( cd "$work_dir" && tar --format=gnu --numeric-owner --sort=name -cf - \
		--mtime="@0" ./debian-binary ./data.tar.gz ./control.tar.gz | gzip -n - > "$package_file" )
done
