---
title: Secure Internet Services with OCaml and MirageOS
logo: success-stories/robur.svg
card_logo: success-stories/white/robur.svg
background: /success-stories/robur-bg.jpg
theme: blue
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
Hannes’ journey began with a passion for improving system infrastructure while fostering a collaborative, non-hierarchical work environment. Initially focused on formal verification during his PhD studies, he found the process to be tedious and impractical for large-scale impact. In his academic work, he encountered dynamically typed languages often used for network stacks, which introduced significant inefficiencies. These languages required runtime checks to ensure safety, resulting in performance costs and errors that only surfaced during execution. Seeking an alternative, Hannes envisioned a better approach: building secure, high-performance systems within a collective that valued open collaboration and sustainable practices.

## Result
In 2018, Hannes and a group of like-minded peers established Robur, a worker-owned collective committed to advancing MirageOS and creating impactful software solutions. The team quickly demonstrated their ability to deliver results. For instance, they developed a high-performance OpenVPN implementation, securing funding in 2019 and again in 2023 to optimize performance and finalize the protocol. Another achievement involved maintaining and extending the QubesOS Firewall, originally developed in 2015, to strengthen the security of isolated virtual machine environments.

Robur also contributed significantly to cryptographic tools and protocols, including Mirage-Crypto and a robust TLS stack. Beyond development, the team uses MirageOS unikernels to host essential services such as their own DNS and CalDav servers. This active use ensures the reliability of their work while directly contributing to the stability and maintenance of MirageOS. These successes reflect the power of their collective model, where decisions about funding, projects, and partnerships are made collaboratively, fostering a culture of shared responsibility.

## Why OCaml
Robur selected OCaml as the backbone of their work due to its unique suitability for building secure and efficient systems. The language's static typing eliminates runtime errors, providing developers with confidence in the reliability of their code. OCaml’s garbage collector and allocation strategy offer predictable performance, enabling developers to intuitively understand how their code will behave under various workloads.

The modular design of OCaml integrates seamlessly with MirageOS, supporting the architecture required for building unikernels. Unlike other languages, such as Haskell, where lazy evaluation can complicate performance and resource predictability, OCaml provides the clarity and control needed for system-level programming. For Hannes, who had experience with languages like Haskell, Java, Scala, and Lisp, OCaml emerged as a practical, efficient choice for creating scalable and secure solutions.

## Solution
Robur has successfully implemented OCaml-based solutions to address complex challenges in network and system infrastructure. Their work on cryptographic protocols, such as TLS and Mirage-Crypto, highlights OCaml’s ability to handle demanding computational tasks with both efficiency and security. These protocols form the backbone of secure communications for many applications.

Performance optimization tools, such as `statmemprof`, are integral to Robur’s workflow, enabling fine-tuned control over resource usage. By hosting services like DNS and CalDav on unikernels, Robur demonstrates the real-world applicability and reliability of their approach. Additionally, their commitment to open-source development allows organizations to benefit from their innovations, as exemplified by the NetHSM project, which transitioned from a closed-source implementation to an open-source solution under Robur’s stewardship.

## Lessons Learned
Robur’s experience provides valuable guidance for those considering OCaml and MirageOS. One key lesson is the importance of starting with small, focused projects to explore OCaml’s advantages, such as type safety, modularity, and predictable performance. Collaboration is another critical factor; contributing to the ecosystem not only strengthens the tools available but also fosters a supportive community of developers.

While OCaml’s ecosystem is robust, there are challenges, including variability in package quality and limited adoption by some industries. Robur emphasizes the value of profiling tools like `statmemprof` for performance tuning and encourages more organizations to adopt OCaml, as broader usage will drive improvements in package quality and tooling.
