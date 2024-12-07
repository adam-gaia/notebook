# anyignore

I sometimes find myself in the strangest of prediciments.

It really gets me wondering why is my software setup so complex?
It appears that I'm working with such a tall scaffolding of software tools that I sometimes get lost in fixing my setup instead of completing my actual end goals.
Are the quality of life improvements these abstractions and tools bring worth the added complexity?

Instead of answering these questions today, I've made another bandaid cli tool that add another layer to the mess.

## The problem

1. \[mdbook\](TODO: link goes here) (what I use to render the html for this notebook from md files) copies the entire working directory into a temp folder before generating any html.

- https://github.com/rust-lang/mdBook/issues/1156
- https://github.com/rust-lang/mdBook/issues/1187

2. \[devenv\](TODO: link here too), my nix-based dev shell intentionally writes a broken symlink  to `${PWD}/./.direnv/flake-inputs/<hash>-source/tests/functional/lang/symlink-resolution/broken"` in all devenv devshell dirs (well I figure its intentional based on the directory path. I haven't actually looked into the code or any gh issues).
   The `.direnv` folder is git ignored, which is at least part of the reason I've never encountered a similar problem before I guess.

So, when mdbook does its copying files into the tmp dir, it copies the `.direnv/` dir (which is totally unnecessary), tries to look at the broken symlink and fails.

```console
$ mdbook build
2024-11-30 20:13:40 [INFO] (mdbook::book): Book building has started
2024-11-30 20:13:40 [INFO] (mdbook::book): Running the html backend
2024-11-30 20:13:40 [ERROR] (mdbook::utils): Error: Rendering failed
2024-11-30 20:13:40 [ERROR] (mdbook::utils):    Caused By: Failed to read "/home/agaia/repo/personal/notebook/./.direnv/flake-inputs/8p8giar71b6aqddqkjckzhirwvjnf02x-source/tests/functional/lang/symlink-resolution/broken"
2024-11-30 20:13:40 [ERROR] (mdbook::utils):    Caused By: No such file or directory (os error 2)
```

Eh, idgaf about looking into what devenv is doing, so lets focus on making mdbook work.

## The solution

`[boxxy](TODO: link)` to the rescue! Boxxy's description from the project's readme:

> boxxy (case-sensitive) is a tool for boxing up misbehaving Linux applications and forcing them to put their files and directories in the right place, without symlinks!

That sounds like just what we need, however manually writing rules would be a pain. I also like the idea of a `.mdbookignore` file.

Like all of my cli project no one will use, I'm going to make it more general than my exact specific use case.
I've written a wrapper around boxxy that uses burntsushi's [ignore crate](https://crates.io/search?q=ignore) to read `.ignore`-like files and write boxxy rules.

\[anyignore\](TODO: link): make any command respect .ignore files.

### Caveats

1. Boxxy must be installed and on the $PATH
1. Linux only (boxxy uses linux namespaces)
1. Any commands ran under `anyignore` won't have access to the correct directory ancestry
1. Boxxy doesn't work the way I wanted it to. I thought that mounted files wouldn't show up in the working dir, but boxxy mounts all of `/` after applying rules, so its only for adding files to places not subtracting.

That last one is a dealbreaker. Boxxy is still a great tool, but not right for this use case.

## The actual solution

I wasn't sure exactly what mechanism could do this, but I knew there must be a way to ignore files at deeper level.

I asked google this question
`https://www.google.com/search?hl=en&q=linux%20virtual%20file%20system%20ignore%20file`
and found this
`https://askubuntu.com/questions/44925/how-can-i-create-a-filesystem-view-of-a-folder-that-excludes-certain-files`
That got me on the right page by pointing me to `https://github.com/gburca/rofs-filtered` I realized that I needed to make a file system.

I call my self a systems developer, but what kind of systems developer am I if I don't know how a file system works.
I know my toy user-space file system isn't exactly the gold standard, but this was an awesome exercise that helped me understand what's going on in a file system.

\[filterfs\](TODO: link) Mount a filtered view into a file system

Resources

- https://github.com/cberner/fuser/tree/master
- https://github.com/cberner/fuser/blob/168705a63a0c47b6cd330291e4a0dc1d14317cd0/examples/simple.rs#L358
- https://github.com/zsiciarz/24daysofrust/blob/master/vol1/src/bin/day15.rs
  - The other writings here look like they could be interesting to browse on another day
  - Linked github https://github.com/zsiciarz/24daysofrust/blob/master/vol1/src/bin/day15.rs
