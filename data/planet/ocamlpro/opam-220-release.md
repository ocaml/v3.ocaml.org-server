---
title: opam 2.2.0 release!
description: 'Feedback on this post is welcomed on Discuss! We are very pleased to
  announce the release of opam 2.2.0, and encourage all users to upgrade. Please read
  on for installation and upgrade instructions. NOTE: this article is cross-posted
  on opam.ocaml.org and ocamlpro.com, and published in discuss.ocaml...'
url: https://ocamlpro.com/blog/2024_07_01_opam_2_2_0_releases
date: 2024-07-01T08:15:07-00:00
preview_image: https://ocamlpro.com/assets/img/logo_ocp_icon.svg
authors:
- "\n    Raja Boujbel - OCamlPro\n  "
source:
---

<p><em>Feedback on this post is welcomed on <a href="https://discuss.ocaml.org/t/ann-opam-2-2-0-is-out/14893">Discuss</a>!</em></p>
<p>We are very pleased to announce the release of opam 2.2.0, and encourage all users to upgrade. Please read on for installation and upgrade instructions.</p>
<blockquote>
<p>NOTE: this article is cross-posted on <a href="https://opam.ocaml.org/blog/">opam.ocaml.org</a> and <a href="https://ocamlpro.com/blog">ocamlpro.com</a>, and published in <a href="https://discuss.ocaml.org/t/ann-opam-2-2-0-is-out/14893">discuss.ocaml.org</a>.</p>
</blockquote>
<h2>Try it!</h2>
<p>In case you plan a possible rollback, you may want to first backup your
<code>~/.opam</code> or <code>$env:LOCALAPPDATAopam</code> directory.</p>
<p>The upgrade instructions are unchanged:</p>
<ol>
<li>Either from binaries: run
</li>
</ol>
<p>For Unix systems</p>
<pre><code class="language-shell-session">bash -c &quot;sh &lt;(curl -fsSL https://raw.githubusercontent.com/ocaml/opam/master/shell/install.sh) --version 2.2.0&quot;
</code></pre>
<p>or from PowerShell for Windows systems</p>
<pre><code class="language-shell-session">Invoke-Expression &quot;&amp; { $(Invoke-RestMethod https://raw.githubusercontent.com/ocaml/opam/master/shell/install.ps1) }&quot;
</code></pre>
<p>or download manually from <a href="https://github.com/ocaml/opam/releases/tag/2.2.0">the Github &quot;Releases&quot; page</a> to your PATH.</p>
<ol start="2">
<li>Or from source, manually: see the instructions in the <a href="https://github.com/ocaml/opam/tree/2.2.0#compiling-this-repo">README</a>.
</li>
</ol>
<p>You should then run:</p>
<pre><code class="language-shell-session">opam init --reinit -ni
</code></pre>
<h2>Changes</h2>
<h3>Major change: Windows support</h3>
<p>After 8 years' effort, opam and opam-repository now have official native Windows
support! A big thank you is due to Andreas Hauptmann (<a href="https://github.com/fdopen">@fdopen</a>),
whose <a href="https://github.com/fdopen/godi-repo">WODI</a> and <a href="https://fdopen.github.io/opam-repository-mingw/">OCaml for Windows</a>
projects were for many years the principal downstream way to obtain OCaml on
Windows, Jun Furuse (<a href="https://github.com/camlspotter">@camlspotter</a>) whose
<a href="https://inbox.vuxu.org/caml-list/CAAoLEWsQK7=qER66Uixx5pq4wLExXovrQWM6b69_fyMmjYFiZA@mail.gmail.com/">initial experimentation with OPAM from Cygwin</a>
formed the basis of opam-repository-mingw, and, most recently,
Jonah Beckford (<a href="https://github.com/JonahBeckford">@jonahbeckford</a>) whose
<a href="https://diskuv.com/dkmlbook/">DkML</a> distribution kept - and keeps - a full
development experience for OCaml available on Windows.</p>
<p>OCaml when used on native Windows requires certain tools from the Unix world
which are provided by either <a href="https://cygwin.com">Cygwin</a> or <a href="https://msys2.org">MSYS2</a>.
We have engineered <code>opam init</code> so that it is possible for a user not to need to
worry about this, with <code>opam</code> managing the Unix world, and the user being able
to use OCaml from either the Command Prompt or PowerShell. However, for the Unix
user coming over to Windows to test their software, it is also possible to have
your own Cygwin/MSYS2 installation and use native Windows opam from that. Please
see the <a href="https://opam.ocaml.org/blog/opam-2-2-0-windows/">previous blog post</a>
for more information.</p>
<p>There are two &quot;ports&quot; of OCaml on native Windows, referred to by the name of
provider of the C compiler. The mingw-w64 port is <a href="https://www.mingw-w64.org/">GCC-based</a>.
opam's external dependency (depext) system works for this port (including
providing GCC itself), and many packages are already well-supported in
opam-repository, thanks to the previous efforts in <a href="https://github.com/fdopen/opam-repository-mingw">opam-repository-mingw</a>.
The MSVC port is <a href="https://visualstudio.microsoft.com/">Visual Studio-based</a>. At
present, there is less support in this ecosystem for external dependencies,
though this is something we expect to work on both in opam-repository and in
subsequent opam releases. In particular, it is necessary to install
Visual Studio or Visual Studio BuildTools separately, but opam will then
automatically find and use the C compiler from Visual Studio.</p>
<h3>Major change: opam tree / opam why</h3>
<p><code>opam tree</code> is a new command showing packages and their dependencies with a tree view.
It is very helpful to determine which packages bring which dependencies in your installed switch.</p>
<pre><code class="language-shell-session">$ opam tree cppo
cppo.1.6.9
&#9500;&#9472;&#9472; base-unix.base
&#9500;&#9472;&#9472; dune.3.8.2 (&gt;= 1.10)
&#9474;   &#9500;&#9472;&#9472; base-threads.base
&#9474;   &#9500;&#9472;&#9472; base-unix.base [*]
&#9474;   &#9492;&#9472;&#9472; ocaml.4.14.1 (&gt;= 4.08)
&#9474;       &#9500;&#9472;&#9472; ocaml-base-compiler.4.14.1 (&gt;= 4.14.1~ &amp; &lt; 4.14.2~)
&#9474;       &#9492;&#9472;&#9472; ocaml-config.2 (&gt;= 2)
&#9474;           &#9492;&#9472;&#9472; ocaml-base-compiler.4.14.1 (&gt;= 4.12.0~) [*]
&#9492;&#9472;&#9472; ocaml.4.14.1 (&gt;= 4.02.3) [*]
</code></pre>
<p>Reverse-dependencies can also be displayed using the new <code>opam why</code> command.
This is useful to examine how dependency versions get constrained.</p>
<pre><code class="language-shell-session">$ opam why cmdliner
cmdliner.1.2.0
&#9500;&#9472;&#9472; (&gt;= 1.1.0) b0.0.0.5
&#9474;   &#9492;&#9472;&#9472; (= 0.0.5) odig.0.0.9
&#9500;&#9472;&#9472; (&gt;= 1.1.0) ocp-browser.1.3.4
&#9500;&#9472;&#9472; (&gt;= 1.0.0) ocp-indent.1.8.1
&#9474;   &#9492;&#9472;&#9472; (&gt;= 1.4.2) ocp-index.1.3.4
&#9474;       &#9492;&#9472;&#9472; (= version) ocp-browser.1.3.4 [*]
&#9500;&#9472;&#9472; (&gt;= 1.1.0) ocp-index.1.3.4 [*]
&#9500;&#9472;&#9472; (&gt;= 1.1.0) odig.0.0.9 [*]
&#9500;&#9472;&#9472; (&gt;= 1.0.0) odoc.2.2.0
&#9474;   &#9492;&#9472;&#9472; (&gt;= 2.0.0) odig.0.0.9 [*]
&#9500;&#9472;&#9472; (&gt;= 1.1.0) opam-client.2.2.0~alpha
&#9474;   &#9500;&#9472;&#9472; (= version) opam.2.2.0~alpha
&#9474;   &#9492;&#9472;&#9472; (= version) opam-devel.2.2.0~alpha
&#9500;&#9472;&#9472; (&gt;= 1.1.0) opam-devel.2.2.0~alpha [*]
&#9500;&#9472;&#9472; (&gt;= 0.9.8) opam-installer.2.2.0~alpha
&#9492;&#9472;&#9472; user-setup.0.7
</code></pre>
<blockquote>
<p>Special thanks to <a href="https://github.com/cannorin">@cannorin</a> for contributing this feature.</p>
</blockquote>
<h3>Major change: with-dev-setup</h3>
<p>There is now a way for a project maintainer to share their project development
tools: the <code>with-dev-setup</code> dependency flag. It is used in the same way as
<code>with-doc</code> and <code>with-test</code>: by adding a <code>{with-dev-setup}</code> filter after a
dependency. It will be ignored when installing normally, but it's pulled in when the
package is explicitly installed with the <code>--with-dev-setup</code> flag specified on
the command line.</p>
<p>For example</p>
<pre><code class="language-shell-session">opam-version: &quot;2.0&quot;
depends: [
  &quot;ocaml&quot;
  &quot;ocp-indent&quot; {with-dev-setup}
]
build: [make]
install: [make &quot;install&quot;]
post-messages:
[ &quot;Thanks for installing the package&quot;
  &quot;as well as its development setup. It will help with your future contributions&quot; {with-dev-setup} ]
</code></pre>
<h3>Major change: opam pin --recursive</h3>
<p>When pinning a package using <code>opam pin</code>, opam looks for opam files in the root directory only.
With recursive pinning, you can now instruct opam to look for <code>.opam</code> files in
subdirectories as well, while maintaining the correct relationship between the <code>.opam</code>
files and the package root for versioning and build purposes.</p>
<p>Recursive pinning is enabled by the following options to <code>opam pin</code> and <code>opam install</code>:</p>
<ul>
<li>With <code>--recursive</code>, opam will look for <code>.opam</code> files recursively in all subdirectories.
</li>
<li>With <code>--subpath &lt;path&gt;</code>, opam will only look for <code>.opam</code> files in the subdirectory <code>&lt;path&gt;</code>.
</li>
</ul>
<p>The two options can be combined: for instance, if your opam packages are stored
as a deep hierarchy in the <code>mylib</code> subdirectory of your project you can try
<code>opam pin . --recursive --subpath mylib</code>.</p>
<p>These options are useful when dealing with a large monorepo-type repository with many
opam libraries spread about.</p>
<h3>New Options</h3>
<ul>
<li>
<p><code>opam switch -</code>, inspired by <code>git switch -</code>, makes opam switch back to the previously
selected global switch.</p>
</li>
<li>
<p><code>opam pin --current</code> fixes a package to its current state (disabling pending
reinstallations or removals from the repository). The installed package will
be pinned to its current installed state, i.e. the pinned opam file is the
one installed.</p>
</li>
<li>
<p><code>opam pin remove --all</code> removes all the pinned packages from a switch.</p>
</li>
<li>
<p><code>opam exec --no-switch</code> removes the opam environment when running a command.
It is useful when you want to launch a command without opam environment changes.</p>
</li>
<li>
<p><code>opam clean --untracked</code> removes untracked files interactively remaining
from previous packages removal.</p>
</li>
<li>
<p><code>opam admin add-constraint &lt;cst&gt; --packages pkg1,pkg2,pkg3</code> applies the given constraint
to a given set of packages</p>
</li>
<li>
<p><code>opam list --base</code> has been renamed into <code>--invariant</code>, reflecting the fact that since opam 2.1 the &quot;base&quot; packages of a switch are instead expressed using a switch invariant.</p>
</li>
<li>
<p><code>opam install --formula &lt;formula&gt;</code> installs a formula instead of a list of packages. This can be useful if you would like to install one package or another one. For example <code>opam install --formula '&quot;extlib&quot; |&quot;extlib-compat&quot;'</code> will install either <code>extlib</code> or <code>extlib-compat</code> depending on what's best for the current switch.</p>
</li>
</ul>
<h3>Miscellaneous changes</h3>
<ul>
<li>The UI now displays a status when extracting an archive or reloading a repository
</li>
<li>Overhauled the implementation of <code>opam env</code>, fixing many corner cases for environment updates and making the reverting of package environment variables precise. As a result, using <code>setenv</code> in an opam file no longer triggers a lint warning.
</li>
<li>Fix parsing pre-opam 2.1.4 switch import files containing extra-files
</li>
<li>Add a new <code>sys-ocaml-system</code> default global eval variable
</li>
<li>Hijack the <code>&quot;%{var?string-if-true:string-if-false-or-undefined}%&quot;</code> syntax to
support extending the variables of packages with <code>+</code> in their name
(<code>conf-c++</code> and <code>conf-g++</code> already exist) using <code>&quot;%{?pgkname:var:}%&quot;</code>
</li>
<li>Fix issues when using fish as shell
</li>
<li>Sandbox: Mark the user temporary directory
(as returned by <code>getconf DARWIN_USER_TEMP_DIR</code>) as writable when TMPDIR
is not defined on macOS
</li>
<li>Add Warning 69: Warn for new syntax when package name in variable in string
interpolation contains several '+' (this is related to the &quot;hijack&quot; item above)
</li>
<li>Add support for Wolfi OS, treating it like Alpine family as it also uses apk
</li>
<li>Sandbox: <code>/tmp</code> is now writable again, restoring POSIX compliance
</li>
<li>Add a new <code>opam admin: new add-extrafiles</code> command to add/check/update the <code>extra-files:</code> field according to the files present in the <code>files/</code> directory
</li>
<li>Add a new <code>opam lint -W @1..9</code> syntax to allow marking a set of warnings as errors
</li>
<li>Fix bugs in the handling of the <code>OPAMCURL</code>, <code>OPAMFETCH</code> and <code>OPAMVERBOSE</code> environment variables
</li>
<li>Fix bugs in the handling of the <code>--assume-built</code> argument
</li>
<li>Software Heritage fallbacks is now supported, but is disabled-by-default for now. For more information you can read one of our <a href="https://opam.ocaml.org/blog/opam-2-2-0-alpha/#Software-Heritage-Binding">previous blog post</a>
</li>
</ul>
<p>And many other general and performance improvements were made and bugs were fixed.
You can take a look to previous blog posts.
API changes and a more detailed description of the changes are listed in:</p>
<ul>
<li><a href="https://github.com/ocaml/opam/releases/tag/2.2.0-alpha">the release note for 2.2.0~alpha</a>
</li>
<li><a href="https://github.com/ocaml/opam/releases/tag/2.2.0-alpha2">the release note for 2.2.0~alpha2</a>
</li>
<li><a href="https://github.com/ocaml/opam/releases/tag/2.2.0-alpha3">the release note for 2.2.0~alpha3</a>
</li>
<li><a href="https://github.com/ocaml/opam/releases/tag/2.2.0-beta1">the release note for 2.2.0~beta1</a>
</li>
<li><a href="https://github.com/ocaml/opam/releases/tag/2.2.0-beta2">the release note for 2.2.0~beta2</a>
</li>
<li><a href="https://github.com/ocaml/opam/releases/tag/2.2.0-beta3">the release note for 2.2.0~beta3</a>
</li>
<li><a href="https://github.com/ocaml/opam/releases/tag/2.2.0-rc1">the release note for 2.2.0~rc1</a>
</li>
<li><a href="https://github.com/ocaml/opam/releases/tag/2.2.0">the release note for 2.2.0</a>
</li>
</ul>
<p>This release also includes PRs improving the documentation and improving
and extending the tests.</p>
<p>Please report any issues to <a href="https://github.com/ocaml/opam/issues">the bug-tracker</a>.</p>
<p>We hope you will enjoy the new features of opam 2.2! &#128239;</p>

