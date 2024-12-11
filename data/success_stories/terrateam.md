---
title: Multi-Tenant Operating System for Satellites
logo: success-stories/parsimoni.png
card_logo: success-stories/white/parsimoni.png
background: /success-stories/parsimoni-bg.jpg
theme: black
synopsis: "SpaceOS revolutionizes satellite software by leveraging OCaml and MirageOS to create a secure, efficient, and lightweight platform for multi-user satellite applications, eliminating the need for bulky Linux environments."
url: https://parsimoni.co/
priority: 7
why_ocaml_reasons:
- Compact Build Artifacts
- Memory Safety
- Formal Verification
- Exceptional Performance and Reliability
- Interoperability with C
- Efficiency in Resource Usage
---

## Challenge

The satellite industry is undergoing major transformations with emerging challenges such as cybersecurity and the need for efficient platforms that enable multiple users to share the same satellite. Traditionally, satellites were single-purpose devices serving a single client, but the advent of "Satellite-as-a-Service" has revolutionized this paradigm. Now, satellites store applications and host multiple users, which introduces critical security implications—a malfunctioning payload must not compromise the operations or security of other users.

Our partner, Thales, provided us with their Earth observation software, which detects satellites using machine learning and AI. This software, initially written in C, was deployed in a Linux container. However, the requirement to ship a complete Linux kernel and environment alongside the application led to significant overhead, including inefficiencies in resource usage and increased memory and processing requirements.

The solution needed to:
- Provide a secure and efficient platform for multi-user satellite applications.
- Reduce the overhead associated with deploying the software in Linux containers.
- Maintain or improve the performance and reliability of existing applications.
- Comply with stringent security standards in the aerospace industry.

## Result

Implementing OCaml with MirageOS led to remarkable results. The SpaceOS solution, deployed as a proof of concept for Thales, achieved:
- A 20x reduction in size compared to the original Linux container-based deployment.
- Substantial reductions in memory and processor resource usage.

These results gained significant industry recognition, including winning the prestigious Airbus Innovation Award at the 2024 Paris Space Week.

The success of this proof of concept has validated the SpaceOS approach within the aerospace industry, establishing it as a benchmark for secure and efficient satellite software. This recognition has opened doors to broader industry partnerships and reinforced our strategic focus on high-assurance software.

The compactness and efficiency of the OCaml-based solution allowed for:
- Enhanced processing capability for onboard satellite applications.
- Demonstrable cost savings in terms of satellite resources.
- Industry accolades, as evidenced by the Airbus Innovation Award and broader adoption interest.

## Why OCaml

OCaml, coupled with MirageOS, was chosen for its:
- Exceptional performance and reliability.
- Memory safety and formal verification capabilities.
- Ability to create highly compact and efficient build artifacts suitable for resource-constrained environments like satellites.

While several technologies were considered, no unikernel-based operating systems besides MirageOS were available for satellite applications. The unique combination of MirageOS and OCaml emerged as the optimal solution for our requirements.

## Solution

OCaml’s interoperability with C allowed us to seamlessly integrate Thales’ Earth observation software into a MirageOS-based unikernel. This eliminated the need for a full Linux environment, significantly reducing overhead while ensuring high security and performance.

The integration process involved:
- Using the existing C application provided by Thales.
- Hosting the application within a MirageOS-based unikernel.
- Creating a secure and efficient SpaceOS container for deployment.

Our tech stack:
- C-based Earth observation software.
- MirageOS (leveraging OCaml).
- SpaceOS as the deployment framework.
- Plans to integrate Unikraft for additional programming language compatibility.

What specific OCaml features or characteristics were most beneficial?
- Compact file size of OCaml build artifacts.
- Memory safety and resilience.
- Formal verification of MirageOS components, enabling compliance with industry security standards.

## Lessons Learned

OCaml, combined with MirageOS, is an excellent choice for projects requiring efficient and secure software. Companies operating in domains such as aerospace, where safety and security are paramount, can benefit greatly from this stack. However, success in such projects requires highly trained engineers.

The project outcomes confirmed the expected benefits of OCaml, such as efficiency and security, solidifying its role as a key enabler in high-assurance software development.

Developing safety- and security-critical software of this caliber demands a specialized skill set, emphasizing the need for expert engineers to harness OCaml's full potential.
