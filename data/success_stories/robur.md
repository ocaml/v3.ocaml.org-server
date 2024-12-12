---
title: Secure Internet Services with OCaml and MirageOS
logo: success-stories/robur.svg
card_logo: success-stories/white/robur.svg
background: /success-stories/robur-bg.jpg
theme: black
synopsis: "A worker-owned collective leverages OCaml and MirageOS to build secure, high-performance, and resource-efficient software solutions"
url: https://robur.coop/
priority: 7
why_ocaml_reasons:
- Static Typing with Strong Guarantees
- High Performance
- Modular Architecture
- Predictability
- Stable Ecosystem
- Optimized Resource Usage
---

## Challenge

When we started Robur in 2018, our mission was to create secure, high-performance, and resource-efficient software solutions. For this, we push the boundaries of MirageOS, a unikernel-based operating system framework. We aim to deploy MirageOS broadly, especially for secure and resource-efficient internet services.

To set up our operations, we faced several challenges:

- **Technical challenges with traditional approaches**: Building network stacks and secure protocols in dynamically-typed languages proved inefficient, introducing runtime checks, reduced performance, and a lack of safety guarantees.
- **Complexity in formal verification**: While initially researching system verification, it became clear this was too tedious and impractical for improving infrastructure at scale.
- **Non-hierarchical organization**: We wanted a cooperative structure, making funding and operational decisions collectively.

## Result

Robur operates as a worker-owned collective, maintaining MirageOS-based systems and securing funding through grants and partnerships.

For our partners, we achieve significant improvements:

- **Performance**: OCaml's static typing and efficient garbage collector allowed us to implement high-performance networking and cryptographic protocols, such as Mirage-crypto and Tls.
- **Error Reduction**: The language's type safety eliminated a class of runtime errors, leading to more reliable systems.
- **Resource Efficiency**: MirageOS unikernels, written in OCaml, demonstrated drastically reduced resource usage, making them suitable for hosting critical services such as DNS, CalDav, and firewalls.
- **Broad Deployment**: Our work has been adopted by industry players for implementing secure protocols, such as OpenVPN and Git. Recent funding allowed us to optimize OpenVPN's performance further, providing measurable speed and efficiency improvements.
- **Open Source Success**: Collaborations, such as NetHSM, transitioned from closed to open source, showcasing the adaptability and impact of OCaml in real-world applications.

## Why OCaml

We chose OCaml for its unique combination of features:

- **Statically-Typed and Predictable**: Unlike dynamically-typed languages, OCaml provides compile-time guarantees, reducing runtime errors and overhead.
- **Performance and Speed**: Its garbage collector and allocation strategy allow developers to write fast, efficient code.
- **Modular Design**: The module system aligns perfectly with the architecture of MirageOS.
- **Ecosystem Stability**: The tools and libraries in OCaml generally "just work," and the compiler team is responsive to improvements.

Traditional approaches using dynamically typed languages proved inadequate for network protocol implementations due to performance overhead and runtime errors. Evaluating statically typed languages, we found that Haskell posed difficulties with performance predictability due to its laziness, while more widely used languages lacked the fine-grained control and assurance required for unikernel development.

## Solution
OCaml addressed our challenges through its robust feature set:

- **Unikernels**: The language’s structure enabled us to build secure, lightweight unikernels tailored to MirageOS.
- **Protocol Development**: Implementing protocols like Tls, Mirage-crypto, and OpenVPN became seamless due to OCaml's performance and safety guarantees.
- **Integration**: OCaml fits well into our tech stack, which includes MirageOS, Coq for some proofs, and tools for resource profiling like `statmemprof`.

## Lessons Learned
Our key insights for others considering OCaml:

- **Start Small**: Begin with a focused project to explore OCaml's advantages, such as type safety and performance.
- **Leverage the Ecosystem**: Tools like `statmemprof` are invaluable for optimizing OCaml programs.
- **Foster Collaboration**: Open source contributions not only improve the ecosystem but also create opportunities for partnerships and funding.

Unexpected benefits:
- OCaml’s predictability made onboarding easier for developers familiar with other statically-typed languages.
- The active community and responsive compiler team simplified debugging and development.

Challenges:
- Package quality varies, particularly regarding resource constraints. Broader adoption and contributions can address this gap.
