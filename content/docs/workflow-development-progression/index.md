## Maintaining semantic coherence in workflow development progression: from jupyter notebooks to python modules, packages, API's

At some point, it may be advisable to move part of code in functions of a **python module** (e.g. `my_functions.py`), stored in the same repository. The functions can be called from the workflow notebook as `from my_functions import my_nice_function; my_nice_function(argument)`.

If some functions are often re-used, they can be stored in external packages, and even published on **pypi** (to allow `pip install my_function_package`).

Sometimes, the **function may be in fact called remotely, though API**. From the point of view of workflow (e.g. notebook) where the function is called there such a remotely executed function may look very similar to local function from a module, giving similar advantages and posing similar challenges.

On should be wary that extracting the functions **somewhat obscure content of the workflow, by introducing structure which is not generally automatically traced by workflow execution provenance tracking**.  
So when reusable part of the workflow matures, it may be extracted and treated as another workflow, providing inputs to the current workflow under development.

It is not feasible to always design workflow to use other workflows by consuming some pre-computed inputs. As described above in this section, workflow development progression often separates some function from within the workflow, or uses.
**SmarkSky** project and in a way in general **renku plugins** essentially acknowledges this feature of the workflows: they use external functions from within the code at random locations, possibly calling them multiple times.

This additional information about functions called by the workflow can be introduced to the workflow metadata with special annotations (see more about workflow annotation in [ODA Workflow Publishing and Discovery Guide](https://github.com/oda-hub/workflow-discovery)), such as `oda:requestsAstroqueryService`. These annotations should be also include information about parameters used to annotate the workflow.
This additional structure associated with workflows will be ingested in the KG. While **it can not be directly interpretted as workflow provenance graph, it is possible to produce additional similar-looking graph with inferred provenance, which is different but analogous to strict renku-derivde provenance**.

