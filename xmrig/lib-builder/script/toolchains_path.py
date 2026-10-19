#!/usr/bin/env python3
"""
Get the Android NDK LLVM toolchain path.
"""
import argparse
import os
import sys


def get_host_tag_or_die():
    if sys.platform.startswith('linux'):
        return 'linux-x86_64'
    if sys.platform == 'darwin':
        return 'darwin-x86_64'
    if sys.platform in ('win32', 'cygwin'):
        return 'windows-x86_64'
    sys.exit('Unsupported platform: ' + sys.platform)


def get_toolchain_path_or_die(ndk, host_tag):
    toolchain_path = os.path.join(ndk, 'toolchains', 'llvm', 'prebuilt', host_tag)
    if not os.path.exists(toolchain_path):
        sys.exit('Could not find toolchain: {}'.format(toolchain_path))
    return toolchain_path


def main():
    parser = argparse.ArgumentParser(description='Return Android NDK LLVM toolchain path')
    parser.add_argument('--ndk', required=True, help='The NDK home directory')
    args = parser.parse_args()
    print(get_toolchain_path_or_die(args.ndk, get_host_tag_or_die()))


if __name__ == '__main__':
    main()
