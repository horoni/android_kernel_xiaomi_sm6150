# SukiSU patches for this 4.14 tree

The KernelSU submodule points at [SukiSU-Nova](https://github.com/SukiSU-Nova/SukiSU-Nova)
branch `builtin`. Its `builtin` branch does not build on a non-GKI 4.14
kernel with `CONFIG_CC_WERROR=y`, so this directory carries the minimal
fixes as a patch series.

The current gitlink points at a local submodule commit created on top of
upstream `4bec532d`. If you ever re-clone this repo (or run
`git submodule update --force` and get upstream `4bec532d` back), apply
the patches again:

```sh
git submodule update --init --recursive
git -C KernelSU am ../sukisu-patches/*.patch
```

If you want the state to survive a fresh clone without manual patching,
push the submodule commit to a fork and update the URL in `.gitmodules`.

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
unconditionally although `static_call` only exists since 5.10.
