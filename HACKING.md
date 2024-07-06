# Hacking on OCaml.org

## Setup and Development

### Setting Up the Project

Before starting to hack, you need a properly configured development environment. Linux and macOS are supported and used daily by the core team. System dependencies include:
* Libev: http://software.schmorp.de/pkg/libev.html
* Oniguruma: https://github.com/kkos/oniguruma
* OpenSSL: https://www.openssl.org/
* GNU Multiple Precision: https://gmplib.org/

The project [`Dockerfile`](./Dockerfile) contains up-to-date system configuration instructions, as used to ship into production. It is written for the Alpine Linux distribution, but it is meant to be adapted to other environments such as Ubuntu, macOS+Homebrew, or others. The GitHub workflow file [`.github/workflows/ci.yml`](.github/workflows/ci.yml) also contains useful commands for Ubuntu and macOS. Since OCaml.org is mostly written in OCaml, a properly configured OCaml development environment is also required, but is not detailed here. Although Docker is used to ship, it is not a requirement to begin hacking. Currently, OCaml.org doesn't yet compile using OCaml 5; version 4.14 of the language is used. It is possible to run workflow files in `.github/workflows` using the [`nektos/act`](https://github.com/nektos/act) tool. For instance, the following command runs the CI checks through GitHub on each pull request (where `ghghgh` is replace by an _ad-hoc_ GitHub token, see: https://github.com/nektos/act#github_token)
```
act -s GITHUB_TOKEN=ghghgh .github/workflows/ci.yml -j build
```


The Makefile contains many commands that can get you up and running. A typical workflow is to clone the repository after forking it.

```
git clone https://github.com/<username>/OCaml.org.git
cd OCaml.org
```

Ensure you have `opam` installed. Opam will manage the OCaml compiler along with all of the OCaml packages needed to build and run the project. By this point, we should all be using some Unix-like system (Linux, macOS, WSL2), so you should [run the opam install script](https://opam.OCaml.org/doc/Install.html#Binary-distribution). There are also manual instructions for people that don't want to run a script from the internet. We assume you are using `opam.2.1.0` or later, which provides a cleaner, friendlier experience when installing system dependencies.

With opam installed, you can now initialise opam with `opam init`. Note that in containers or WSL2, you will have to run `opam init --disable-sandboxing`. Opam might complain about some missing system dependencies like `unzip`, `cc` (a C compiler like `gcc`), etc. Make sure to install these before `opam init`.

Finally from the root of your project, you can setup a [local opam switch](https://opam.OCaml.org/doc/Manual.html#Switches) and install the dependencies. There is a single `make` target to do just that.

```
make switch
```

If you don't want a local opam switch and are happy to install everything globally (in the opam sense), then you can just install the dependencies directly.

```
make deps
```

Opam will likely ask questions about installing system dependencies. Ror the project to work, you will have to answer yes to installing these.

### Running the Server

After building the project, you can run the server with:

```bash
make start
```

To start the server in watch mode, you can run:

```bash
make watch
```

This will restart the server on filesystem changes.

### Running Tests

You can run the unit test suite with:

```bash
make test
```

### Building the Playground

The OCaml Playground is compiled separately from the rest of the server. The generated assets can be found in
[`playground/asset/`](./playground/asset/).

You can build the playground from the root of the project. There is no need to move to the `./playground/` directory for the following commands.

To regenerate the playground, you need to install the playground's dependencies first:

```
make deps -C playground
```

After the dependencies have been installed, simply build the project to regenerate the JavaScript assets:

```
make playground
```

Once the compilation is complete and successuful, commit the newly-generated assets in OCaml.org's Git repo and merge the pull request. 

### Deploying

Commits added on some branches are automatically deployed:
- `main` on <https://OCaml.org/>
- `staging` on <https://staging.OCaml.org/>

The deployment pipeline is managed in <https://github.com/ocurrent/ocurrent-deployer>, which listens to the `main` and `staging` branches and builds the site using the `Dockerfile` at the project's root. You can monitor the state of each deployment on [`deploy.ci.OCaml.org`](https://deploy.ci.OCaml.org/?repo=ocaml/OCaml.org).

To test the deployment locally, run the following commands:

```
docker build -t ocamlorg .
docker run -p 8080:8080  ocamlorg
```

This will build the Docker image and run a Docker container with the port `8080` mapped to the HTTP server.

With the Docker container running, visit the site at <http://localhost:8080/>.

The Docker images automatically build from the `live` and `staging` branches. They are then pushed to Docker Hub: https://hub.docker.com/r/ocurrent/v3.OCaml.org-server.

### Staging Pull Requests

We [aim to keep the `staging` branch as close as possible to the `main`
branch](doc/FOR_MAINTAINERS.md#how-we-maintain-the-staging-branch), with only a few PRs added on top of it.

The maintainers will add your pull request to `staging` if it is worthwhile
to do so. For example, documentation PRs or new features where we need testing
and feedback from the community will generally be live on `staging` for a while
before they get merged.

### Managing Dependencies

OCaml.org is using an opam switch that is local and bound to a pinned commit in `opam-repository`. This is intended to protect the build from upstream regressions. The opam repository is specified in three (3) places:
```
Dockerfile
Makefile
.github/workflows/*.yml
```

When bringing up OCaml.org to a newer pin, the commit hash found it those files must be changed all at once.

Once the opam repo pin is updated, the local switch must be updated using the following command:
```sh
opam repo set-url pin git+https://github.com/ocaml/opam-repository#<commit-hash>
```

Where `<commit-hash>` is the pinned hash specified in the files mentioned above.

Once this is done, you can run `opam update` and `opam upgrade`. If OCamlFormat
was upgraded in the process, the files `.ocamlformat` and
`.github/workflows/ci.yml` must be modified with the currently installed version
of OCamlFormat.

## Repository Structure

The following snippet describes the repository structure:

```text
.
├── asset/
|   The static assets served by the site.
│
├── data/
|   Data used by OCaml.org in Yaml and Markdown format.
│
├── playground/
│   The source and generated assets for the OCaml Playground
│
├── src
│   ├── global
│   │   Project wide definitions
│   │
│   ├── ocamlorg_data
│   │   The result of compiling all of the information in `/data` into OCaml modules.
│   │
│   ├── ocamlorg_frontend
│   │   All of the front-end code primarily using .eml files (OCaml + HTML).
│   │
│   ├── ocamlorg_package
│   │   The library for constructing opam-repository statistics and information (e.g. rev deps).
│   │
│   └── ocamlorg_web
│       The main entry-point of the server.
│
├── tool/
│   Sources for development tools such as the `ocamlorg_data` code generator.
│
├── dune
├── dune-project
│   Dune file used to mark the root of the project and define project-wide parameters.
│   For the documentation of the syntax, see https://dune.readthedocs.io/en/stable/dune-files.html#dune-project.
│
├── ocamlorg.opam
├── ocamlorg.opam.template
│   opam package definitions.
│
├── CONTRIBUTING.md
│
├── Dockerfile
│   Dockerfile used to build and deploy the site in production.
│
├── LICENSE
├── LICENSE-3RD-PARTY
│   Licenses of the source code, data and vendored third-party projects.
│
├── Makefile
│   `Makefile` containing common development commands.
│
├── README.md
│
└── tailwind.config.js
    Configuration used by TailwindCSS to generate the CSS file for the site.
```
