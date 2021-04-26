# Details about the reasoning engines

Workflows entities in the KG can undergo various transformations. One key transformation is **currying**, understood in the same way as function [currying](https://en.wikipedia.org/wiki/Currying) - since workflow, for our purposes, is very similar to a **function**. **Currying** transforms workflow with parameters with workflow with less parameters (arguments), possibly without any parameters. We assume that **only workflow without parameters can be computed (executed)**. 

Workflow **execution** is 

This approach separates:
* workflow **composition**, which becomes one of the workflow transformation operations.
* workflow **execution** (computing)

Reasoning engine is itself a process (workflow) which takes as an input some KG state, and produces new triples (which can be inserted back in the KG).

## Currying worker


## Execution

workflows have a property which describes what can execute them. Two forms used now are

**Executing, computing the workflow is also a reasoning action**, deriving equivalence between the given workflow and a trivial worklow which implements to request to data store.
