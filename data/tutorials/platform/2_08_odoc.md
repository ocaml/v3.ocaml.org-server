---
id: "generating-documentation"
title: "Generating Documentation With odoc"
short_title: "Generating Documentation"
description: |
  How to use odoc to generate documentation.
category: "Documentation"
---

The documentation rendering tool `odoc` generates documentation
in the form of HTML, LaTeX, or man pages,
from the docstrings and interfaces of the project's modules

Dune can run `odoc` on your project to generate HTML documentation with this command:

```shell
$ opam exec -- dune build @doc

# Unix or macOS
$ open _build/default/_doc/_html/index.html

# Windows
$ explorer _build\default\_doc\_html\index.html
```

## Generating `.mld` Documentation Pages

In addition to documenting the publicly-visible API of your project,
`odoc` also gives you the ability to add individual documentation pages.

For example, to replace the automatically generated documentation
index file, you have to add a file `index.mld` to your project.

To make Dune find your `.mld` pages and process them with `odoc`,
the `dune` file in the same directory as your `.mld` files needs to
include this stanza:

```
(documentation
 (package name-of-your-package))
```

A common place to put `.mld` files is a directory named `doc` or `docs`.

For more information on how to write documentation pages for `odoc`,
see the [`odoc` for authors documentation](https://ocaml.github.io/odoc/odoc_for_authors.html#doc-pages).
