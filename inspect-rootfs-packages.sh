#!/bin/sh
set -eu

for package_name in attr curl cgi-io coreutils tar; do
	package_file=$(find /home/toor/r28s/bin/packages -name "${package_name}_*.ipk" -print -quit)
	echo "== ${package_name} =="
	echo "$package_file"
	if [ -n "$package_file" ]; then
		tar -xOf "$package_file" ./control.tar.gz | tar -xzO ./control | \
			grep -E '^(Package|Architecture|Depends):'
	fi
done

grep -n -A 2 -B 1 -E '^Package: (attr|curl|cgi-io|coreutils|tar)$' \
	/home/toor/r28s/bin/packages/aarch64_generic/*/Packages || true
