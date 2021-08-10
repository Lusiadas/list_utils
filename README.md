# list-utils
> A plugin for [Oh My Fish](https://www.github.com/oh-my-fish/oh-my-fish).

[![GPL License](https://img.shields.io/badge/license-GPL-blue.svg?longCache=true&style=flat-square)](/LICENSE)
[![Fish Shell Version](https://img.shields.io/badge/fish-v2.7.1-blue.svg?style=flat-square)](https://fishshell.com)
[![Oh My Fish Framework](https://img.shields.io/badge/Oh%20My%20Fish-Framework-blue.svg?style=flat-square)](https://www.github.com/oh-my-fish/oh-my-fish)

<br/>

## Description

Get notified when packages are added or removed from repositories upon updating; and filter the output of `apt list/search`.

### Usage

`"apt list/search [options] packages ...`

## Options

```
-n/--new [package] ...
Include only packages that were  newly added to repositories.

-o/--old
Uninstall packages and remove them from the package list.

-i/--installed
Include only installed packages.

-r/--repo [repository]
Include only packages from a given repository.

apt -h/--help
Display these instructions.
```

## Install

```fish
omf repositories add https://gitlab.com/argonautica/argonautica 
omf install package_list
```