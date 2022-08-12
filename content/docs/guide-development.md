# Workflow development Guide

Workflows are all things that can be computed, broadly speaking. 

For reproducibility, we want our workflows to be repeatable: producing the same output every time they are computed. 
This is easy enough to do in first approximation, but might be harder to achieve than it seems when the workflow relies on external resources. But we track every execution so it is not necessary to be overly concerned about these delicate details at every moment.

Generally, we want the workflows to be parametrized. Non-parametrized but strickly repeatable notebooks are equivalent to their output data.

One way to create them in ODA is to build **jupyter notebook**.

## Guide to a simple ODA Jupyter Notebook workflow


* write your notebook, and make sure it runs from top to bottom
* make a requirements.txt will the modules you need for this notebook
* parameterize the notebook, by creating cell with the following tag "parameters" (see [papermill manual](https://papermill.readthedocs.io/en/latest/usage-parameterize.html#designate-parameters-for-a-cell)):
* define the notebook output, similarly creating cell with tag "outputs". 
  * outputs may be strings, floats, lists
  * outputs may be also strings which contain filenames for valid files. If they do, the whole file will be considered output.
* install nb2workflow tooling `pip install nb2workflow[cwl,oda] --upgrade`
* inspect the notebook `nbinspect my-notebook.ipynb`
* try to run the notebook `nbrun my-notebook.ipynb`
  * it will use all default parameters 
  * you can specify parameters as `nbrun --inp-nbins=10 my-notebook.ipynb`, if `nbins` happens to be one of the parameters.
* try to start the service `nb2service my-notebook.ipynb`

## Workflows development progression: towards python modules, packages, API's

At some point, it may be advisable to move part of code in functions of a **python module** (e.g. `my_functions.py`), stored in the same repository. The functions can be called from the workflow notebook as `from my_functions import my_nice_function; my_nice_function(argument)`.

If some functions are often re-used, they can be stored in external packages, and even published on **pypi** (to allow `pip install my_function_package`).

Sometimes, the **function may be in fact called remotely, though API**. From the point of view of workflow (e.g. notebook) where the function is called there such a remotely executed function may look very similar to local function from a module, giving similar advantages and posing similar challenges.

On should be wary that extracting the functions **somewhat obscure content of the workflow, by introducing structure which is not generally automatically traced by workflow execution provenance tracking**.  
So when reusable part of the workflow matures, it may be extracted and treated as another workflow, providing inputs to the current workflow under development.

It is not feasible to always design workflow to use other workflows by consuming some pre-computed inputs. As described above in this section, workflow development progression often separates some function from within the workflow, or uses.
**SmarkSky** project and in a way in general **renku plugins** essentially acknowledges this feature of the workflows: they use external functions from within the code at random locations, possibly calling them multiple times.

This additional information about functions called by the workflow can be introduced to the workflow metadata with special annotations (see more about workflow annotation in [ODA Workflow Publishing and Discovery Guide](https://github.com/oda-hub/workflow-discovery)), such as `oda:requestsAstroqueryService`. These annotations should be also include information about parameters used to annotate the workflow.
This additional structure associated with workflows will be ingested in the KG. While **it can not be directly interpretted as workflow provenance graph, it is possible to produce additional similar-looking graph with inferred provenance, which is different but analogous to strict renku-derivde provenance**.

