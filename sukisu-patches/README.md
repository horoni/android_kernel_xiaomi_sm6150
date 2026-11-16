# SukiSU patches for this 4.14 tree

The `KernelSU` submodule points at
[SukiSU-Nova](https://github.com/SukiSU-Nova/SukiSU-Nova) branch `builtin`
(upstream commit `4bec532d`). Its `builtin` branch does not build on a
non-GKI 4.14 kernel with `CONFIG_CC_WERROR=y`, so this directory carries
the minimal fixes as a patch series.

The gitlink intentionally stays at the upstream commit: the fixes are
**not** committed in the submodule, otherwise a fresh clone could not
fetch the parent commit (GitHub cannot serve submodule commits that only
exist locally).

## Usage

After a fresh clone, or after the submodule was reset/updated:

```sh
git submodule update --init --recursive
./sukisu-patches/apply.sh
```

The script is idempotent: already-applied patches are skipped. Changes
stay in the submodule working tree, so `git status` will show
`modified: KernelSU (modified content)`, and
`git submodule update --force` reverts them (re-run the script after).

## Series

* `0001-kernel-fix-4.14-non-GKI-build-with-Werror.patch`
  * `preinit/common/preinit.h` - do not redefine `KSU_NO_PREINIT`
    (`-DKSU_NO_PREINIT=1` already comes from the Makefile when
    `usr/include` has not been generated).
  * `kernel_compat.h` - `kvcalloc()` for kernels older than 4.18.
  * `extension/kpm/kpm.c` - 3-argument `access_ok()` before 5.0.
  * `selinux/rules.c` - declare `pol`/`old_pol` only on the 5.10+
    policy replacement path.

## Note

`include/linux/static_call.h` in the top-level tree is a separate
compatibility stub: SukiSU's `kernel_includes.h` includes it
unconditionally although `static_call` only exists since 5.10. It is
tracked in the main repository, so it needs no patching.
