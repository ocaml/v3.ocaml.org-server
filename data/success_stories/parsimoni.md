---
title: Infrastructure as Code Platform
logo: success-stories/terrateam.svg
card_logo: success-stories/white/terrateam.svg
background: /success-stories/terrateam-bg.jpg
theme: black
synopsis: "Terrateam is a SaaS platform for managing infrastructure as code, addressing the challenge of building a scalable, reliable, and maintainable system for handling complex workflows in high-performance infrastructure management."
url: https://terrateam.io
priority: 7
why_ocaml_reasons:
- Strong Type System
- High Performance
- Concurrency Support
- Ease of Maintenance
- Predictable Runtime
---

## Challenge

Terrateam is a Software as a Service (SaaS) platform that simplifies the management and deployment of infrastructure as code. It integrates with GitHub, allowing teams to manage their infrastructure using tools like Terraform and OpenTofu. Terrateam enables efficient collaboration, automates deployment processes, and ensures that infrastructure is consistently up-to-date and well-managed.

We were facing the challenge of building a robust, scalable, and highly reliable platform for managing complex infrastructure as code workflows. Since Infrastructure as Code is critical for organizations, we needed a solution that would ensure performance, safety, and maintainability as our codebase grew. As a startup, we anticipated frequent refactoring due to changing requirements, so we required a language that would allow for large, invasive refactorings without introducing errors.

Our key requirements were:

* High performance to handle large-scale infrastructure operations
* A strong type system to catch errors at compile time
* Excellent concurrency support to manage multiple workflows simultaneously
* The ability to write clean, maintainable code for handling complex business logic

## Result

After implementing the OCaml solution, Terrateam became extremely performant and scalable, efficiently managing many concurrent user requests with minimal CPU and memory usage, even across a small number of containers. This has led to significant performance gains and improved scalability, allowing us to maintain high availability with minimal infrastructure.

The most notable impact has been the efficiency with which our system has been developed. Using OCaml, we have been able to build the entire system with a lean team, all while responding rapidly to customer needs. OCaml’s strong type system has allowed us to make substantial code changes without causing regressions, ensuring high code quality and maintainability.

## Why OCaml

We chose OCaml because it strikes the perfect balance between performance, reliability, and ease of maintenance. Having used it for over a decade, we were familiar with the language and appreciated the benefits of its strong, expressive type system. The simplicity of the OCaml runtime allows us to easily predict the performance and memory impacts of changes, which is critical in infrastructure management.

We considered other technologies but found OCaml’s combination of type safety and performance made it the best choice. The language’s ability to encode system invariants into the type system ensures fewer errors and easier maintenance. For example, we validate all input upon receipt, transforming it into internal types to ensure that business logic always operates with correct values. We also avoid catch-all matches, ensuring that changes to variants are always addressed where necessary.

Although we use some bash and Python where appropriate (e.g., for GitHub actions), OCaml is the core of our technology stack.

## Solution

OCaml addressed our challenges by offering a practical and expressive type system, supported by features like pattern matching, lightweight syntax, and a robust module system. The separation of implementation and API via the module system allows for better code structure and maintainability. OCaml’s understandable runtime has been crucial in enabling our small team to be highly productive without worrying about performance bottlenecks or errors.

Our tech stack includes:

* Backend service: OCaml (with various libraries)
* Web server: Nginx
* Database: PostgreSQL
* Hosting provider: Fly.io
* Containerization: Docker
* Version control and CI/CD: GitHub + GitHub Actions

## Lessons Learned

For companies considering OCaml, we advise leveraging the module system fully, as it sets OCaml apart from other languages. Don’t hesitate to implement your own libraries and frameworks—the expressiveness of OCaml makes this both feasible and efficient. Also, use the advanced parts of the type system, like GADTs, judiciously to avoid overcomplicating your codebase.

While we haven't encountered unexpected benefits from using OCaml, it has met our expectations perfectly. The best tool for the job is one you enjoy using every day, and for us, that’s OCaml.

One challenge we are still addressing is delivering OCaml-based components that run on end-user systems, which requires either supporting multiple system configurations or using Docker containers. Delivering a seamless experience in these environments remains an area for improvement.

## Open Source

Our product is Open Source and you can inspect the [source code of Terrateam.io on GitHub](https://github.com/terrateamio/terrateam)!
