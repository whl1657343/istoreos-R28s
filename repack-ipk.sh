#!/bin/sh
set -eu

package_dir=/home/toor/r28s/bin/targets/rockchip/armv8/packages
work_root=$(mktemp -d)
trap 'rm -rf "$work_root"' EXIT

for package_file in "$package_dir"/*.ipk; do
	[ -f "$package_file" ] || continue
	work_dir="$work_root/${package_file##*/}"
	mkdir "$work_dir"
	tar -xzf "$package_file" -C "$work_dir"
	ar rD "$work_dir/repacked.ipk" \
		"$work_dir/debian-binary" \
		"$work_dir/data.tar.gz" \
		"$work_dir/control.tar.gz"
	mv "$work_dir/repacked.ipk" "$package_file"
done

ar t "$package_dir/base-files_1~47a915e58d_aarch64_generic.ipk"
