# proot-distro-completion
A completion script for proot-distro.

## Introduction
This repository provides a Bash completion script for [proot-distro](https://github.com/termux/proot-distro).

## Installation
Just run these few lines of commands:
```bash
wget https://raw.githubusercontent.com/marquis-ng/proot-distro-completion/main/proot-distro-completion.bash
mkdir -p /data/data/com.termux/files/usr/etc/bash_completion.d
mv proot-distro-completion.bash /data/data/com.termux/files/usr/etc/bash_completion.d/proot-distro-completion.bash
```
Done! Just open a new session and see the tab completion work!

### If it still doesn't work...
The `bash-completion` package seems not installed. Install it with:
```
pkg install bash-completion
```
It should start working.

## Optional
For people (like me) who use a lot of `proot-distro`, they may symlink the `proot-distro` script to `pd`:
```
ln -s /data/data/com.termux/files/usr/bin/proot-distro /data/data/com.termux/files/usr/bin/pd
```
The completion will be available for the `pd` command too.

**Note: other symlinks to `proot-distro` will not work because the support for the `pd` symlink is hard-coded.**
