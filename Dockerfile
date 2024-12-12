# syntax=docker/dockerfile:1
FROM ocaml/opam:alpine-3.21-ocaml-5.2 AS build
RUN sudo ln -sf /usr/bin/opam-2.3 /usr/bin/opam && opam init --reinit -ni

# Install system dependencies
RUN --mount=type=cache,target=/var/cache/apk,sharing=locked \
    sudo ln -s /var/cache/apk /etc/apk/cache && \
    sudo apk -U upgrade && sudo apk add \
    autoconf \
    curl-dev \
    gmp-dev \
    inotify-tools \
    libev-dev \
    oniguruma-dev \
    openssl-dev

# Branch freeze was opam-repo HEAD at the time of commit
RUN cd ~/opam-repository && git reset --hard de786e28dbea73843ad5e5f0290a4e81fba39370 && opam update

WORKDIR /home/opam

# Install opam dependencies
COPY --chown=opam --link ocamlorg.opam .
RUN --mount=type=cache,target=/home/opam/.opam/download-cache,sharing=locked,uid=1000,gid=1000 \
    opam install . --deps-only

# Build project
COPY --chown=opam . .
RUN opam exec -- dune build @install --profile=release

# Launch project in order to generate the package state cache
RUN cd ~/opam-repository && git checkout master && git pull origin master && opam update
ENV OCAMLORG_PKG_STATE_PATH=package.state \
    OCAMLORG_REPO_PATH=opam-repository
RUN touch package.state && ./init-cache package.state


FROM alpine:3.21

RUN --mount=type=cache,target=/var/cache/apk,sharing=locked \
    ln -s /var/cache/apk /etc/apk/cache && \
    apk -U upgrade && apk add \
    git \
    gmp \
    libev

COPY --from=build --link /home/opam/package.state /var/package.state
COPY --from=build --link /home/opam/opam-repository /var/opam-repository
COPY --from=build --link /home/opam/_build/default/src/ocamlorg_web/bin/main.exe /bin/server

COPY --link playground/asset playground/asset

ADD --keep-git-dir --link https://github.com/ocaml-web/html-compiler-manuals /manual

RUN git config --global --add safe.directory /var/opam-repository

ENV DREAM_VERBOSITY=info \
    OCAMLORG_HTTP_PORT=8080 \
    OCAMLORG_MANUAL_PATH=/manual \
    OCAMLORG_PKG_STATE_PATH=/var/package.state \
    OCAMLORG_REPO_PATH=/var/opam-repository/

EXPOSE 8080

ENTRYPOINT ["/bin/server"]
