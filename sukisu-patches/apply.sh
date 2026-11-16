#!/bin/sh
# Apply the SukiSU build-fix series to the KernelSU submodule.
#
# The gitlink in this repository stays at upstream SukiSU-Nova/builtin so
# that "git submodule update" always works from a fresh clone. The fixes
# are applied to the submodule working tree instead, which means they are
# not committed and have to be re-applied after the submodule is reset.
#
# Usage: ./sukisu-patches/apply.sh
set -eu

top=$(git rev-parse --show-toplevel)
cd "$top"

if [ ! -e KernelSU/.git ] && [ ! -f KernelSU/.git ]; then
	echo "error: KernelSU submodule is not initialized" >&2
	echo "       run: git submodule update --init --recursive" >&2
	exit 1
fi

found=0
for patch in sukisu-patches/*.patch; do
	if [ ! -e "$patch" ]; then
		continue
	fi
	found=1
	name=$(basename "$patch")
	if git -C KernelSU apply --reverse --check "$top/$patch" 2>/dev/null; then
		echo "already applied: $name"
	elif git -C KernelSU apply --check "$top/$patch" 2>/dev/null; then
		git -C KernelSU apply "$top/$patch"
		echo "applied: $name"
	else
		echo "error: cannot apply $name" >&2
		echo "       is KernelSU at the expected upstream commit?" >&2
		echo "       expected: $(git ls-tree HEAD KernelSU | awk '{print $3}')" >&2
		exit 1
	fi
done

if [ "$found" -eq 0 ]; then
	echo "error: no patches found in sukisu-patches/" >&2
	exit 1
fi
