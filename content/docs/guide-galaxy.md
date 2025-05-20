# Converting a notebook repository into a Galaxy tool.

A workflow prepared following the [Development Guide](docs/guide-development) can be easily converted into a [Galaxy](https://github.com/galaxyproject/galaxy) tool.

To trigger the automatic creation of the tool, add `galaxy-tool` as a "Project topic" in the GitLab project. This triggers the bot that monitors the [GitLab group](https://gitlab.renkulab.io/astronomy/mmoda). The bot attempts to convert the repository into a Galaxy tool and creates a corresponding pull request in the [tools-astro repository](https://github.com/esg-epfl-apc/tools-astro). The conversion process is handled by the `galaxy.py` module from the [nb2workflow](https://github.com/oda-hub/nb2workflow) package. If the automatic process fails for any reason, you can debug it using `nb2galaxy` cli directly. Run `nb2galaxy --help` to see the command-line options.

## Resolution of the dependencies

The dependencies of a Galaxy tool must be conda packages (not PyPI packages). Therefore, the conversion module tries to reconcile the dependencies listed in both `requirements.txt` and `environment.yml` using Conda. First, each package from `requirements.txt` is searched by Conda. If the package with the same name exists in the configured conda channels (only `conda-forge` by default), it is included in the final list of packages for reconciliation. Otherwise, the package is ignored and a comment is added to the generated tool represented as an XML file.

In the end, all dependencies are resolved together to obtain fixed versions of the required packages that are written in the tool's XML file.

## Additional configuration

You can manually include a Galaxy toolshed definition file `.shed.yml`. If this file is not present, one is auto-generated with default options (see below).

The tool documentation is automatically extracted from the `galaxy_help.md` file - located in the root of the repository - and then added the tool xml file. In addition to the documentation, this markdown file may begin with a YAML frontmatter block (delimited by `---`) for additional configuration options:

- `description: <string>` - sets the tool description which can be used in `.shed.yml` if this file is not explicitly provided (default value: the tool name);
- `long_description: <string>` - similar to `description: <string>`, but provides a more detailed explanation;
- `additional_files: <list|string>` - specifies extra files from the repository required by the tool. By default, `nb2galaxy` converts only the notebooks to scripts and adds them to the tool directory. Therefore, if you define helper modules or the notebooks depend on data files from the GitLab repository, list them here. The specification (a single string or a list of strings) should follow the [glob](https://docs.python.org/3/library/glob.html#glob.glob) syntax (with `recursive=True`). **Note**: that the tool dir and the workdir, from where the tool is executed are different in Galaxy. The conversion module sets two environment variables: `GALAXY_TOOL_DIR` and `BASEDIR` both pointing to the tool root directory.

You also need to define the `citations.bib` bibtex file containing tool references. If an entry contains DOI, only this DOI will be used in the Galaxy tool xml (preferred way), otherwise, full cictation in the bibtex format will be added.

## Tool linting, testing and preview

The https://github.com/esg-epfl-apc/tools-astro repository has CI/CD configured to lint the tool definition and run tool tests. You can inspect the workflow results and correct the original GitLab repo to fix prolems. The auto-generated tool tests check that tool is able to execute without exceptions with the default parameters.

The bot will automatically add a `test-live` label to the github PR, this triggers a CI/CD workflow, that publishes the tool preview to our [staging server](https://galaxy.odahub.fr) in the **Astro tools (staging)** section to preview it and manually test on the live Galaxy instance.
