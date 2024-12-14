---
title: Financial Compliance with Automated Reasoning
logo: success-stories/imandra.svg
card_logo: success-stories/white/imandra.svg
background: /success-stories/imandra-bg.jpg
theme: black
synopsis: "Imandra leverages OCaml to develop innovative automated reasoning tools that modernize regulatory compliance, streamline workflows, and ensure correctness in complex financial systems."
url: https://www.imandra.ai/
priority: 7
why_ocaml_reasons:
- Expressive Type System
- High Performance
- Unified Tech Stack
- Strong Ecosystem
- Interoperability
- Community and Resources
---

## Challenge
At Imandra, we specialize in automated reasoning systems, tackling the complex challenges of nonlinear systems in industries such as finance, autonomous vehicles, and formal verification. Our mission is to create tools that can prove properties and verify algorithms for highly regulated and intricate environments. When we started, we recognized a critical need for formal verification tools capable of handling the complexity and nonlinear behavior inherent in these domains.

The 2008 financial crisis marked a turning point for the regulatory landscape of financial institutions. Compliance with new regulations became a pressing issue, as violations were no longer just theoretical risks but actively enforced. Trading algorithms, which are inherently nonlinear systems, required robust verification to ensure compliance with these strict standards. We also noticed that informal specifications, often documented in PDFs, were prone to errors and inefficiencies. Financial institutions needed a reliable and formalized approach to ensure their systems adhered to both regulatory requirements and operational reliability.

Simultaneously, the autonomous systems industry demanded tools capable of reasoning about nonlinear control flow, such as those used in drones or analog circuit controllers. Existing tools, like SAT solvers and SMT solvers, could not provide the higher-order polymorphic reasoning needed for these applications. We needed to build a system that addressed these gaps while meeting the scalability and efficiency requirements of real-world applications.

## Result
By adopting OCaml as our primary development language, we achieved transformative results across multiple dimensions. OCaml's ability to handle the rigorous demands of formal verification while offering excellent performance and scalability has been pivotal. This decision has enabled us to deliver a unified solution for automated reasoning, streamlining compliance processes and operational workflows in the financial sector.

One of the most impactful outcomes has been the development of our domain-specific language (DSL), a subset of OCaml designed for writing machine-reasonable specifications. This DSL has modernized how financial institutions approach regulatory compliance by transforming informal PDF-based specifications into formal, machine-readable formats. This shift has reduced errors, improved reliability, and enabled automated certification processes.

In the finance industry, our tools have become essential for verifying trading algorithms and ensuring compliance with complex regulations. Clients can now analyze high-level execution algorithms, verify interactions across hundreds of trading venues, and ensure the correctness and safety of these systems. Additionally, our “digital twin” technology allows verified exchange models to run in real-time production environments, offering unparalleled operational guarantees. These advancements position us as leaders in the formal verification space, with solutions widely adopted by financial institutions seeking robust compliance tools.

You can [watch a high-level explainer video here](https://vimeo.com/123746101).

## Why OCaml
Our choice of OCaml stems from the language’s unique combination of features, which make it an ideal fit for our needs. We initially experimented with PolyML due to its multicore support and our familiarity with it from academic research. However, we ultimately chose OCaml for its larger community, more extensive ecosystem, and adoption by prominent financial institutions like Jane Street and LexiFi. This existing presence in the finance world made OCaml an easier sell to potential clients.

OCaml’s type system provides a critical advantage, offering a sweet spot between expressiveness and practicality. Less-typed languages lack the rigor needed for formal verification, while dependently typed languages are overly restrictive for our use case. OCaml strikes the perfect balance, enabling us to build a high-performance, scalable system without compromising on type safety or maintainability.

Another key factor is OCaml’s robust ecosystem. Tools like OPAM and Dune streamline package management and build processes, while resources like *Real World OCaml* facilitate onboarding for new engineers. Over time, OCaml’s interoperability has allowed us to integrate with external tools written in C and Rust, which we have gradually replaced with pure OCaml implementations. This consistency across our tech stack further reinforces our decision to standardize on OCaml.

## Solution
OCaml empowers us to address our challenges with remarkable efficiency and precision. One of its standout features is the ability to efficiently execute formal models. This capability enables us to compile verified exchange models into “digital twins,” which can run in production systems or operate alongside them as real-time audit tools. This approach provides unparalleled assurance of correctness and safety in mission-critical environments.

Our migration to OCaml 5 marks another significant milestone, unlocking improved performance and scalability through multicore support. This advancement is particularly important for computationally intensive tasks like theorem proving and model verification. Additionally, OCaml’s flexibility allows us to build our frontend systems using Eliom, ensuring seamless integration between frontend and backend workflows. This unified tech stack not only streamlines development but also facilitates onboarding for new engineers, who can start with simpler tasks on the frontend before progressing to more complex backend and verification work.

Our DSL, based on OCaml, plays a pivotal role in modernizing financial compliance. By replacing error-prone PDF specifications with formal descriptions written in the DSL, we enable clients to automate analysis, identify edge cases, and achieve regulatory certification with greater confidence. Our tools have since become a cornerstone for financial institutions seeking reliable, efficient compliance solutions.

## Lessons Learned
Our journey with OCaml offers valuable lessons for other companies considering the language for similar use cases. One of the most important takeaways is the benefit of using OCaml across the entire tech stack. This approach simplifies development, facilitates collaboration, and accelerates onboarding for new engineers. By starting with simpler frontend tasks and gradually advancing to backend and formal verification roles, engineers can build their expertise incrementally.

Another lesson is the importance of leveraging OCaml’s ecosystem and community. Tools like OPAM and Dune, combined with educational resources like *Real World OCaml*, have been instrumental in accelerating adoption and reducing the learning curve. Our experience also highlights the value of a robust type system, which ensures reliability and maintainability without compromising on performance.

While migrating to OCaml 5 presented challenges, the long-term benefits in terms of performance and scalability make it a worthwhile investment. This experience underscores the importance of planning and commitment when adopting new technologies.
