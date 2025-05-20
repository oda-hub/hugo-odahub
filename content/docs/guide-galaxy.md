# Converting a notebook repository into a Galaxy tool.

A workflow prepared according to the [Development Guide](guide-development.md) can be easily converted into a [Galaxy](https://github.com/galaxyproject/galaxy) tool.

Once the `galaxy-tool` is added as a "Project topic" in the GitLab project settings, the automatic conversion is triggered, i.e. the bot that monitors the [GitLab group](https://gitlab.renkulab.io/astronomy/mmoda) attempts to convert the repository into a Galaxy tool and finally, it creates a corresponding pull request in the [tools-astro repository](https://github.com/esg-epfl-apc/tools-astro). The conversion process is handled by the `galaxy.py` module from the [nb2workflow](https://github.com/oda-hub/nb2workflow) package. If the automatic conversion process fails, one can debug it using `nb2galaxy` cli directly. Run `nb2galaxy --help` to see the command-line options.

## Resolution of the dependencies

Galaxy tools require dependencies to be available as Conda packages (not PyPI packages). Therefore, the conversion module attempts to reconcile the dependencies listed in both `requirements.txt` and `environment.yml` using Conda. First, each package from `requirements.txt` is searched by Conda. If the package with the same name exists in the configured conda channels (only `conda-forge` by default), it is included in the final list of packages for reconciliation. Otherwise, the package is ignored and a comment is added to the generated tool represented as an XML file.

In the end, all dependencies are resolved together to obtain fixed versions of the required packages that are written in the tool's XML file.

## Additional configuration

A Galaxy ToolShed definition file `.shed.yml` can be manually included. If this file is not present, one is auto-generated with default options.
Here is an example of minimal, automatically generated shed file:

```yaml
categories:
- Astronomy
description: Tool Name
homepage_url: null
long_description: Tool Name
name: tool_name_astro_tool
owner: astroteam
remote_repository_url: https://github.com/esg-epfl-apc/tools-astro/tree/main/tools
type: unrestricted
```

The two keys to be preferably edited are `description` and `long_description`, these values can be set besides other Galaxy-tool-related options (see below).

The tool documentation is automatically extracted from the `galaxy_help.md` file - located in the root directory of the repository - and then added the tool XML file. The same markdown file may begin with a YAML frontmatter block (delimited by `---`) for additional configuration options:

- `description: <string>` - a short description of the tool which can be used in `.shed.yml` if this file is not explicitly provided (default value: the tool name);
- `long_description: <string>` - similar to `description: <string>`, but provides a more detailed explanation;
- `additional_files: <list|string>` - specifies extra files (e.g. helper modules and data files) from the GitLab repository required by the tool, since by default, `nb2galaxy` converts only the notebooks to scripts and adds them to the tool directory. The paths can be a single string or a list of strings and should follow the [glob](https://docs.python.org/3/library/glob.html#glob.glob) syntax (with `recursive=True`). **Note**: In Galaxy, the tool directory and the workdir (i.e. from where the tool is executed) are different. To address this, the conversion module sets two environment variables: `GALAXY_TOOL_DIR` and `BASEDIR`, both pointing to the tool root directory.

Finally, a `citations.bib` file that contains tool references must be created. If an entry contains a DOI, only the DOI is used in the Galaxy tool XML file (this is the preferred method). Otherwise, the full BibTeX citation is included.

## Tool linting, testing and preview

The [tools-astro repository](https://github.com/esg-epfl-apc/tools-astro) is set up with CI/CD pipelines that automatically lint the tool definition files and run tests to ensure the tool, with the default parameters, executes correctly and without exceptions. One can inspect the pipeline results and then fix issues or improve the original GitLab repository accordingly.

Additionally, when the bot creates a GitHub pull request, it adds a `test-live` label. This triggers a CI/CD workflow that publishes a preview of the tool to our [staging server](https://galaxy.odahub.fr), under the **Astro tools (staging)** section. This allows the developer of the tool to preview and manually test it on the live Galaxy instance.
