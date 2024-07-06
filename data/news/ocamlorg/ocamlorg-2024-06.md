---
title: "OCaml.org Newsletter: June 2024"
description: Monthly update from the OCaml.org team.
date: "2024-07-03"
tags: [ocamlorg]
---

Welcome to the June 2024 edition of the OCaml.org newsletter! This update has been compiled by the OCaml.org team. You can find [previous updates](https://discuss.ocaml.org/tag/ocamlorg-newsletter) on Discuss.

Our goal is to make OCaml.org the best resource for anyone who wants to get started and be productive in OCaml. The OCaml.org newsletter provides an update on our progress towards that goal and an overview of the changes we are working on.

We couldn't do it without all the amazing people who help us review, revise, and create better OCaml documentation and work on issues. Your participation enables us to so much more than we could just by ourselves. Thank you!

This newsletter covers:
- **Recipes for the OCaml Cookbook:** Help us make the OCaml Cookbook really useful by contributing and reviewing recipes for common tasks!
- **Community & Marketing Pages Rework:** Implementation work in progress.
- **General Improvements:** As usual, we also worked on general maintenance and improvements, so we're highlighting some of the work that happened below.

## Open Issues for Contributors

You can find [open issues for contributors here](https://github.com/ocaml/ocaml.org/issues?q=is%3Aissue+is%3Aopen+label%3A%22help+wanted%22+no%3Aassignee)!

## Recipes for the OCaml Cookbook

The OCaml Cookbook is a place where OCaml developers share how to solve common tasks using packages from the ecosystem.

A recipe is a code sample and explanations on how to perform a task using a combination of open-source libraries.

The Cookbook is live at [ocaml.org/cookbook](https://ocaml.org/cookbook).

Here's how you can help:

1. Review, then [open pull requests for cookbook recipes](https://github.com/ocaml/ocaml.org/pulls?q=is%3Apr+is%3Aopen+label%3ACookbook)!
2. Contribute new recipes and tasks for the cookbook!

**Relevant PRs and Activities:**
- (open) PR: Cookbook Extract Links From HTML [ocaml/ocaml.org#2552](https://github.com/ocaml/ocaml.org/pull/2552) by [@ggsmith842](https://github.com/ggsmith842)
- (open) PR: Cookbook Measures of Central Tendency [ocaml/ocaml.org#2540](https://github.com/ocaml/ocaml.org/pull/2540) by [@ggsmith842](https://github.com/ggsmith842)
- (open) PR: Cookbook Send a POST/PATCH Request w/ Authentication [ocaml/ocaml.org#2534](https://github.com/ocaml/ocaml.org/pull/2534)
- PR: Cookbook Normalise Vector [ocaml/ocaml.org#2513](https://github.com/ocaml/ocaml.org/pull/2513) by [@ggsmith842](https://github.com/ggsmith842)
- PR: (docs) Cookbook "Validate an Email Address" With `re` [ocaml/ocaml.org#2518](https://github.com/ocaml/ocaml.org/pull/2518) by [@ggsmith842](https://github.com/ggsmith842)



## Community & Marketing Pages Rework

We have [UI designs for the reworked and new pages of the community section](https://www.figma.com/file/7hmoWkQP9PgLTfZCqiZMWa/OCaml-Community-Pages?type=design&node-id=637%3A4539&mode=design&t=RpQlGvOpeg1a93AZ-1), and implementation is in progress.

**Relevant PRs and Activities:**

- PR: Events feed [ocaml/ocaml.org#2495](https://github.com/ocaml/ocaml.org/pull/2495) by [@ishar19](https://github.com/ishar19)
- (open) PR: OCaml In Numbers: A dashboard with key metrics and statistics about the OCaml community [ocaml/ocaml.org#2514](https://github.com/ocaml/ocaml.org/pull/2514) by [@tmattio](https://github.com/tmattio)
- PR: Add fields professor, enrollment, and `last_check` to Academic [ocaml/ocaml.org#2489](https://github.com/ocaml/ocaml.org/pull/2489) by [@cuihtlauac](https://github.com/cuihtlauac)
- PR: Fix: render full title of OCaml Cookbook recipe as HTML page title  [ocaml/ocaml.org#2560](https://github.com/ocaml/ocaml.org/pull/2560)  by [@sabine](https://github.com/sabine)

## General Improvements and Data Additions

**Summary:**

* To reduce repetition of the module interface definitions relating to `ood-gen` (the tool that turns the files in the `data/` folder into OCaml modules), types have been factored out. This hopefully makes it simpler to contribute to changes to the data models.
* Materials for some of the tutorials have been published under the https://github.com/ocaml-web GitHub organisation: [“Your First OCaml Program”](https://github.com/ocaml-web/ocamlorg-docs-your-first-program), [“Modules”](https://github.com/ocaml-web/ocamlorg-docs-modules), [“Functors”](https://github.com/ocaml-web/ocamlorg-docs-functors), and [“Libraries With Dune”](https://github.com/ocaml-web/ocamlorg-docs-libraries-dune).
* The OCamlFormat version used to format the project is now 0.26.2.

**Relevant PRs and Activities:**
- PR: Update code highlighting color scheme [ocaml/ocaml.org#2496](https://github.com/ocaml/ocaml.org/pull/2496) by [@Siddhant-K-code](https://github.com/Siddhant-K-code)
- Data
  - PR: (data) Add OCaml.org newsletter May 2024 [ocaml/ocaml.org#2498](https://github.com/ocaml/ocaml.org/pull/2498) by [@sabine](https://github.com/sabine)
  - PR: Add changelog entry for Merlin `4.15-414/501` [ocaml/ocaml.org#2473](https://github.com/ocaml/ocaml.org/pull/2473) by [@voodoos](https://github.com/voodoos)
  - PR: Add the announement for opam 2.2.0~beta3 [ocaml/ocaml.org#2509](https://github.com/ocaml/ocaml.org/pull/2509) by [@kit-ty-kate](https://github.com/kit-ty-kate)
  - PR: Add missing changelog entries [ocaml/ocaml.org#2476](https://github.com/ocaml/ocaml.org/pull/2476)  by [@tmattio](https://github.com/tmattio)
  - PR: Add changelog entry for `ppxlib.0.32.1` release [ocaml/ocaml.org#2479](https://github.com/ocaml/ocaml.org/pull/2479) by [@NathanReb](https://github.com/NathanReb)
  - PR: (data) add `odoc` dev meeting to governance [ocaml/ocaml.org#2521](https://github.com/ocaml/ocaml.org/pull/2521)  by [@sabine](https://github.com/sabine)
  - PR: (data) Update meeting link and frequency in governance for OCaml.org [ocaml/ocaml.org#2542](https://github.com/ocaml/ocaml.org/pull/2542)  by [@sabine](https://github.com/sabine)
- Documentation:
  - PR: Prerequisites for Libraries With Dune [ocaml/ocaml.org#2551](https://github.com/ocaml/ocaml.org/pull/2551)  by [@cuihtlauac](https://github.com/cuihtlauac)
  - Added repositories holding materials for some of the tutorials at https://github.com/ocalm-web
    - PR:`ocaml-web` repo link [ocaml/ocaml.org#2547](https://github.com/ocaml/ocaml.org/pull/2547)  by [@cuihtlauac](https://github.com/cuihtlauac)
    - PR: Prerequisites and `ocaml-web` repo link [ocaml/ocaml.org#2544](https://github.com/ocaml/ocaml.org/pull/2544)  by [@cuihtlauac](https://github.com/cuihtlauac)
    - PR: Prerequisites and `ocaml-web` repo link [ocaml/ocaml.org#2543](https://github.com/ocaml/ocaml.org/pull/2543)  by [@cuihtlauac](https://github.com/cuihtlauac)
    - PR: Fix typo in `0it_00_values_functions.md` [ocaml/ocaml.org#2548](https://github.com/ocaml/ocaml.org/pull/2548)  by [@boisgera](https://github.com/boisgera)
    - PR: `ocaml-web` tutorial material URLs [ocaml/ocaml.org#2550](https://github.com/ocaml/ocaml.org/pull/2550)  by [@cuihtlauac](https://github.com/cuihtlauac)
  - PR: In "Modules" tutorial: Fix `dune` files [ocaml/ocaml.org#2535](https://github.com/ocaml/ocaml.org/pull/2535)  by [@cuihtlauac](https://github.com/cuihtlauac)
  - PR: Fix typo in "Tour of OCaml"  [ocaml/ocaml.org#2519](https://github.com/ocaml/ocaml.org/pull/2519) by [@blackwindforce](https://github.com/blackwindforce)
  - PR: Clarification on pattern matching and definitions [ocaml/ocaml.org#2500](https://github.com/ocaml/ocaml.org/pull/2500) by [@cuihtlauac](https://github.com/cuihtlauac)
- Refactoring / Code health:
  - Factor out types on `ood-gen` tool that parses the files in the `data/` folder:
      - PR: Single data type definition for Outreachy [ocaml/ocaml.org#2481](https://github.com/ocaml/ocaml.org/pull/2481)  by [@cuihtlauac](https://github.com/cuihtlauac)
      - PR: Single data type definition for Resource [ocaml/ocaml.org#2533](https://github.com/ocaml/ocaml.org/pull/2533)  by [@cuihtlauac](https://github.com/cuihtlauac)
      - PR: Single data type defintion for Success_story [ocaml/ocaml.org#2536](https://github.com/ocaml/ocaml.org/pull/2536)  by [@cuihtlauac](https://github.com/cuihtlauac)
      - PR: Single data type defintion for Tool [ocaml/ocaml.org#2538](https://github.com/ocaml/ocaml.org/pull/2538)  by [@cuihtlauac](https://github.com/cuihtlauac)
      - PR: Single type for Tool_page [ocaml/ocaml.org#2539](https://github.com/ocaml/ocaml.org/pull/2539)  by [@cuihtlauac](https://github.com/cuihtlauac)
      - PR: Single type for Book [ocaml/ocaml.org#2488](https://github.com/ocaml/ocaml.org/pull/2488)  by [@cuihtlauac](https://github.com/cuihtlauac)
      - PR: Single data type definition for Exercise [ocaml/ocaml.org#2497](https://github.com/ocaml/ocaml.org/pull/2497)  by [@cuihtlauac](https://github.com/cuihtlauac)
      - PR: Single data type definitions for Planet [ocaml/ocaml.org#2529](https://github.com/ocaml/ocaml.org/pull/2529) by [@cuihtlauac](https://github.com/cuihtlauac)
      - PR: Single data type definition for Release [ocaml/ocaml.org#2531](https://github.com/ocaml/ocaml.org/pull/2531) by [@cuihtlauac](https://github.com/cuihtlauac)
      - PR: Single data type definition for Changelog [ocaml/ocaml.org#2492](https://github.com/ocaml/ocaml.org/pull/2492)  by [@cuihtlauac](https://github.com/cuihtlauac)
      - PR: Single data type definition for Cookbook [ocaml/ocaml.org#2490](https://github.com/ocaml/ocaml.org/pull/2490)  by [@cuihtlauac](https://github.com/cuihtlauac)
      - PR: Single data type definition for Governance [ocaml/ocaml.org#2504](https://github.com/ocaml/ocaml.org/pull/2504)  by [@cuihtlauac](https://github.com/cuihtlauac)
      - PR: Single data type definitions for Tutorial [ocaml/ocaml.org#2555](https://github.com/ocaml/ocaml.org/pull/2555)  by [@cuihtlauac](https://github.com/cuihtlauac)
      - PR: Single data type definition for Event [ocaml/ocaml.org#2559](https://github.com/ocaml/ocaml.org/pull/2559) by [@cuihtlauac](https://github.com/cuihtlauac)
      - PR: Single data type definition for Industrial_user [ocaml/ocaml.org#2505](https://github.com/ocaml/ocaml.org/pull/2505)  by [@cuihtlauac](https://github.com/cuihtlauac)
      - PR: Single type for Is_ocaml_yet [ocaml/ocaml.org#2508](https://github.com/ocaml/ocaml.org/pull/2508)  by [@cuihtlauac](https://github.com/cuihtlauac)
      - PR: Single type definition for Job [ocaml/ocaml.org#2516](https://github.com/ocaml/ocaml.org/pull/2516)  by [@cuihtlauac](https://github.com/cuihtlauac)
      - PR: Single data type definition for News [ocaml/ocaml.org#2520](https://github.com/ocaml/ocaml.org/pull/2520)  by [@cuihtlauac](https://github.com/cuihtlauac)
      - PR: Single data type defintion for opam_user [ocaml/ocaml.org#2522](https://github.com/ocaml/ocaml.org/pull/2522)  by [@cuihtlauac](https://github.com/cuihtlauac)
      - PR: Single data type definition for Workshop [ocaml/ocaml.org#2541](https://github.com/ocaml/ocaml.org/pull/2541)  by [@cuihtlauac](https://github.com/cuihtlauac)
      - PR: Single data type defintion for Watch [ocaml/ocaml.org#2545](https://github.com/ocaml/ocaml.org/pull/2545)  by [@cuihtlauac](https://github.com/cuihtlauac)
      - PR: Single data type definition for Page [ocaml/ocaml.org#2524](https://github.com/ocaml/ocaml.org/pull/2524)  by [@cuihtlauac](https://github.com/cuihtlauac)
      - PR: Single data type definition for Paper [ocaml/ocaml.org#2526](https://github.com/ocaml/ocaml.org/pull/2526)  by [@cuihtlauac](https://github.com/cuihtlauac)
      - PR: Single data type definition for Academic_Institution [ocaml/ocaml.org#2477](https://github.com/ocaml/ocaml.org/pull/2477) by [@cuihtlauac](https://github.com/cuihtlauac)
      - PR: Single data type definition for Code_examples [ocaml/ocaml.org#2501](https://github.com/ocaml/ocaml.org/pull/2501)  by [@cuihtlauac](https://github.com/cuihtlauac)
  - PR: Remove redundant data type Watch [ocaml/ocaml.org#2507](https://github.com/ocaml/ocaml.org/pull/2507) by [@cuihtlauac](https://github.com/cuihtlauac)
  - Increase OCamlFormat version used to format the project from 0.25.1 to 0.26.2
    - PR: Bringup OCamlFormat [ocaml/ocaml.org#2482](https://github.com/ocaml/ocaml.org/pull/2482)  by [@cuihtlauac](https://github.com/cuihtlauac)
    - PR: Formatting [ocaml/ocaml.org#2484](https://github.com/ocaml/ocaml.org/pull/2484)  by [@cuihtlauac](https://github.com/cuihtlauac)
    - PR: Add information on switch pin update [ocaml/ocaml.org#2483](https://github.com/ocaml/ocaml.org/pull/2483)  by [@cuihtlauac](https://github.com/cuihtlauac)
    - PR: Bringup OCamlFormat in CI [ocaml/ocaml.org#2485](https://github.com/ocaml/ocaml.org/pull/2485)  by [@cuihtlauac](https://github.com/cuihtlauac)
    - PR: Add information on switch pin update, cont'd [ocaml/ocaml.org#2486](https://github.com/ocaml/ocaml.org/pull/2486)  by [@cuihtlauac](https://github.com/cuihtlauac)
  - PR: Rename Utils `map_files` into `map_md_files` [ocaml/ocaml.org#2515](https://github.com/ocaml/ocaml.org/pull/2515)  by [@cuihtlauac](https://github.com/cuihtlauac)
  - PR: Remove unused Video data [ocaml/ocaml.org#2506](https://github.com/ocaml/ocaml.org/pull/2506) by [@cuihtlauac](https://github.com/cuihtlauac)
  - PR: Remove unused `ood/video` files [ocaml/ocaml.org#2546](https://github.com/ocaml/ocaml.org/pull/2546)  by [@cuihtlauac](https://github.com/cuihtlauac)