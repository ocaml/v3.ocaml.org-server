---
title: Marketing Intelligence Tools Powered by Big Data
logo: success-stories/ahrefs.svg
card_logo: success-stories/white/ahrefs.svg
background: /success-stories/ahrefs-bg.jpg
theme: blue
synopsis: "Ahrefs leverages OCaml to achieve massive scalability, processing billions of daily requests, running a peta-byte scale web crawler, while maintaining a lean, efficient team."
url: https://ahrefs.com/
priority: 2
why_ocaml_reasons:
- Type Safety
- Expressiveness and Reliability
- Unified Technology Stack
- Integration with JavaScript Ecosystem
- Customizability
- Scalability
- Performance
---

## Challenge

Ahrefs has always been committed to operational efficiency and self-reliance, even as it grew to become a leader in the SEO industry. Unlike many VC-funded companies, Ahrefs has chosen to prioritize maintaining a small, focused team while achieving exceptional output. However, this approach came with its own set of challenges.

In 2017, the state of technology presented significant limitations. JavaScript tooling was far from ideal, offering poor editor integration and limited safety features, which hindered developer productivity. Similarly, the PHP and jQuery stack being used lacked the structure and robustness of a modern frontend framework. This resulted in inefficiencies and created communication barriers between frontend and backend teams.

Another challenge was scaling operations while keeping the team small. Ahrefs needed a cohesive and type-safe technology stack that worked seamlessly across the frontend and backend, ensuring confidence in the codebase and maintaining a high standard of output without the need to hire excessively.

Finally, the lack of a direct connection between the frontend and backend often required backend engineers to manually create APIs, leading to delays and inefficiencies in delivering features. To address these challenges, Ahrefs sought a solution that could empower their lean team to work more effectively, with minimal friction and strong collaboration between all parts of the stack.

## Result

Adopting OCaml was a transformative decision for Ahrefs, enabling the company to overcome its challenges and significantly improve operations. By transitioning the entire frontend team from PHP and jQuery to OCaml, supported by Melange and React, Ahrefs achieved a full-stack evolution.

One of the most impactful outcomes was the ability to share data types between the frontend and backend. This streamlined development processes, reduced friction, and allowed engineers to contribute meaningfully across the entire stack. With this new technology foundation, Ahrefs not only maintained but significantly scaled its operations.

Today, Ahrefs’ systems handle **5 billion frontend requests per day** and process a staggering **500 billion backend requests per day**. The codebase powering this scale has grown to **1.5 million lines of OCaml code**, underscoring the robustness and scalability of their technology stack. These advancements have helped Ahrefs become a trusted industry leader, relied upon by **44% of Fortune 500 companies**.
For more up-to-date statistics, see [Ahrefs' statistics and metrics page](https://ahrefs.com/big-data).

## Why OCaml

Ahrefs chose OCaml as the backbone of its technology stack because of its unique ability to combine expressiveness and reliability. The language allowed developers to write concise, efficient code that remained stable over the long term, with systems often running for years without surprises.

One of the key reasons for selecting OCaml was its versatility in enabling a unified technology stack. The ability to use shared types between frontend and backend eliminated redundant work, improved collaboration, and ensured consistency across the board. Additionally, OCaml’s robust type system provided engineers with a high degree of confidence in their code, significantly reducing errors and simplifying maintenance.

OCaml’s ecosystem, especially with the introduction of Melange (formerly BuckleScript), allowed Ahrefs to bridge the gap between OCaml’s strong typing and the flexibility of the JavaScript ecosystem. Initially adopted for backend crawling, OCaml’s utility expanded to the frontend when Melange made it possible to compile OCaml to JavaScript. This pivotal decision empowered Ahrefs to create tools that made their vast datasets more accessible and actionable.

## Solution

OCaml addresses Ahrefs’ challenges, providing the tools needed to build a cohesive, scalable, and efficient technology stack. One of the most impactful features was its end-to-end type safety. Using tools like ATD, Ahrefs generated shared types for both frontend and backend development, ensuring consistency and reducing the likelihood of bugs.

OCaml’s expressiveness allows Ahrefs to avoid relying on bloated, one-size-fits-all frameworks. Instead, the team could craft solutions tailored to their specific needs, resulting in more efficient and maintainable systems. This customization extended to their tech stack, which seamlessly integrated OCaml with complementary technologies like Melange, React, Clickhouse, MySQL, and Elasticsearch.

The unified OCaml stack also fosters a more collaborative environment. By allowing all engineers to contribute across domains, Ahrefs broke down silos and improved overall productivity. The result was a streamlined development process that enabled the company to maintain high standards of output while keeping its team small and focused.

## Lessons Learned

Ahrefs’ journey with OCaml provides valuable insights for other companies considering a similar path:

1. **Embrace Simplicity:** OCaml’s type system is intuitive yet powerful, enabling developers to build expressive and reliable applications without unnecessary complexity.
2. **Invest in Learning:** Training the team in OCaml is essential but rewarding. Tools like the Melange playground can make the onboarding process smoother and more approachable.
3. **Build Tailored Solutions:** By leveraging OCaml’s expressiveness, Ahrefs avoided generic frameworks in favor of custom-built solutions that addressed their unique needs. While this approach requires more ownership, it results in greater efficiency and precision.
4. **Anticipate Challenges with Bindings:** Writing bindings can be complex, but resources from the Melange community simplify this process.
5. **Adopt Gradually:** Starting with small contributions to libraries or limited integrations can help teams build confidence before transitioning fully to OCaml.

## Open Source

Ahrefs is proud to support the OCaml ecosystem by contributing tools and libraries that benefit the broader community. These contributions include:

- **[Melange Recharts](https://github.com/ahrefs/melange-recharts):** Recharts bindings for Melange.
- **[Ahrefs DevKit](https://github.com/ahrefs/devkit):** A suite of internal tools and utilities.
- **[Melange Bindings](https://github.com/melange-community/bindings):** A community-driven resource for bindings.
- **[Melange JSON PPX](https://github.com/ahrefs/melange-json-ppx):** A replacement for the ATD runtime in BuckleScript.
- **[OCaml Community Tools](https://github.com/ocaml-community):** Contributions to widely used tools like `ocurl` and `ocaml-mariadb`.
