# Converting notebook repository into the Galaxy tool.

The workflow that's prepared following [Development guide] can also be easily converted to the [Galaxy](https://github.com/galaxyproject/galaxy) tool.

To trigger the automatic creation of the tool, add the `galaxy-tool` as a topic at the project Gitlab. This will trigger the bot, that monitors the GitLab group. It will try to convert the repo to the Galaxy tool and create a corresponding PR in the https://github.com/esg-epfl-apc/tools-astro repository. The bot uses `galaxy.py` module of the [nb2workflow](https://github.com/oda-hub/nb2workflow) package to do the conversion. If automatic conversion is failed for some reason you can debug it by using `nb2galaxy` cli directly. Call `nb2galaxy --help` to see the comand-line options.

## Resolution of the dependencies

Because galaxy tool can only have conda packages as dependencies, not pypi packages, the conversion module tries to reconcile both packages from `requirements.txt` and `environment.yml` with conda. First, every package from `requirements.txt` is searched by conda. If the package with the same name exists in the configured conda channels (only `conda-forge` by default), the package will be added to the final list of packages for reconciliation. Otherwise, the package is ignored, and a comment will be added to the tool xml file.

In the end, all dependencies are resolved together to obtain fixed versions of the requirements in the tool xml.

## Additional configuration

You can add manual Galaxy toolshed definition file `.shed.yml`. If not exist, it will be generated with default options (see below).

The tool help will be converted and added to the tool xml from the `galaxy_help.md` file in the root of the repository.

Apart from help text, this markdown file may contain a frontmatter (yaml block at the beginning of the file, separated by `---`) with additional configuration options:

- `description: <string>` will be added to the `.shed.yml` if this file is not explicitly provided (the default value is just a tool name).
- `long_description: <string>` -- the same for the `long_description`.
- `additional_files: <list|string>` is used if the tool needs additionsl files from the repo to function. By default, `nb2galaxy` only converts notebooks to script and adds them to the tool directory. If you define helper modules, or notebooks need some additional data files from the repo, be sure to specify them here. The specification can be a single string or a list of strings, each having [glob](https://docs.python.org/3/library/glob.html#glob.glob) syntax (with `recursive=True`). Be aware, that the tool dir and the workdir, from where the tool is executed are different in Galaxy. The conversion module sets two environment variables: `GALAXY_TOOL_DIR` and `BASEDIR` both pointing to the tool root directory.

You also need to define the `citations.bib` bibtex file containing tool references. If an entry contains DOI, only this DOI will be used in the Galaxy tool xml (preferred way), otherwise, full cictation in the bibtex format will be added.

## Tool linting, testing and preview

The https://github.com/esg-epfl-apc/tools-astro repository has CI/CD configured to lint the tool definition and run tool tests. You can inspect the workflow results and correct the original GitLab repo to fix prolems. The auto-generated tool tests check that tool is able to execute without exceptions with the default parameters.

The bot will automatically add a `test-live` label to the github PR, this triggers a CI/CD workflow, that publishes the tool preview to our [staging server](https://galaxy.odahub.fr) in the **Astro tools (staging)** section to preview it and manually test on the live Galaxy instance.
