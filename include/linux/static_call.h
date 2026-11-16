/* SPDX-License-Identifier: GPL-2.0 */
#ifndef _LINUX_STATIC_CALL_H
#define _LINUX_STATIC_CALL_H

/*
 * Compatibility stub for the static_call API, which was introduced in
 * Linux 5.10.
 *
 * SukiSU's kernel/kernel_includes.h unconditionally includes this header
 * even on kernels that predate static_call, while the builtin branch does
 * not use the static_call API on those kernels (the only reference is the
 * include itself). Keep this file empty until a real static_call backport
 * is available.
 */

#endif /* _LINUX_STATIC_CALL_H */
