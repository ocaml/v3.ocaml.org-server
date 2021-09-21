.DEFAULT_GOAL := all

ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
$(eval $(ARGS):;@:)

# Dependencies used in development, for ood-gen in particular
DEV_DEPS := \
"yaml>=3.0" \
ppx_deriving_yaml \
ezjsonm \
ptime \
fmt \
fpath \
piaf \
lambdasoup \
cmdliner \
crunch \
ppx_deriving_yaml \
"omd>=2.0.0~alpha2" \
xmlm \
uri

.PHONY: all
all:
	opam exec -- dune build --root .

.PHONY: deps
deps: ## Install development dependencies
	opam install -y dune-release ocamlformat utop ocaml-lsp-server $(DEV_DEPS)
	npm install
	opam install --deps-only --with-test --with-doc -y .

.PHONY: create_switch
create_switch:
	opam switch create . 4.12.0 --no-install

.PHONY: switch
switch: create_switch deps ## Create an opam switch and install development dependencies

.PHONY: lock
lock: ## Generate a lock file
	opam lock -y .

.PHONY: build
build: ## Build the project, including non installable libraries and executables
	opam exec -- dune build --root .

.PHONY: install
install: all ## Install the packages on the system
	opam exec -- dune install --root .

.PHONY: start
start: all ## Run the produced executable
	opam exec -- dune build @run --force --no-buffer

.PHONY: test
test: ## Run the unit tests
	opam exec -- dune build --root . @src/runtest

.PHONY: clean
clean: ## Clean build artifacts and other generated files
	opam exec -- dune clean --root .

.PHONY: doc
doc: ## Generate odoc documentation
	opam exec -- dune build --root . @doc

.PHONY: fmt
fmt: ## Format the codebase with ocamlformat
	opam exec -- dune build --root . --auto-promote @fmt

.PHONY: watch
watch: ## Watch for the filesystem and rebuild on every change
	opam exec -- dune build @run -w --force --no-buffer

.PHONY: utop
utop: ## Run a REPL and link with the project's libraries
	opam exec -- dune utop --root . . -- -implicit-bindings

.PHONY: gen-data
gen-data: ## Generate the data files
	opam exec -- dune exec --root . tool/ood-gen/bin/gen.exe -- academic_institution > src/ocamlorg_data/academic_institution.ml
	opam exec -- dune exec --root . tool/ood-gen/bin/gen.exe -- book > src/ocamlorg_data/book.ml
	opam exec -- dune exec --root . tool/ood-gen/bin/gen.exe -- event > src/ocamlorg_data/event.ml
	opam exec -- dune exec --root . tool/ood-gen/bin/gen.exe -- industrial_user > src/ocamlorg_data/industrial_user.ml
	opam exec -- dune exec --root . tool/ood-gen/bin/gen.exe -- paper > src/ocamlorg_data/paper.ml
	opam exec -- dune exec --root . tool/ood-gen/bin/gen.exe -- release > src/ocamlorg_data/release.ml
	opam exec -- dune exec --root . tool/ood-gen/bin/gen.exe -- success_story > src/ocamlorg_data/success_story.ml
	opam exec -- dune exec --root . tool/ood-gen/bin/gen.exe -- tool > src/ocamlorg_data/tool.ml
	opam exec -- dune exec --root . tool/ood-gen/bin/gen.exe -- tutorial > src/ocamlorg_data/tutorial.ml
	opam exec -- dune exec --root . tool/ood-gen/bin/gen.exe -- video > src/ocamlorg_data/video.ml
	opam exec -- dune exec --root . tool/ood-gen/bin/gen.exe -- watch > src/ocamlorg_data/watch.ml
	opam exec -- dune exec --root . tool/ood-gen/bin/gen.exe -- news > src/ocamlorg_data/news.ml
	opam exec -- dune exec --root . tool/ood-gen/bin/gen.exe -- opam_user > src/ocamlorg_data/opam_user.ml
	opam exec -- dune exec --root . tool/ood-gen/bin/gen.exe -- workshop > src/ocamlorg_data/workshop.ml
	opam exec -- dune build --root . --auto-promote @fmt
