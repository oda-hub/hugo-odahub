# Workflow development Guide

Workflows are all things that can be computed, broadly speaking. 

For reproducibility, we want our workflows to be repeatable: producing the same output every time they are computed. 
This is easy enough to do in first approximation, but might be harder to achieve than it seems when the workflow relies on external resources. But we track every execution so it is not necessary to be overly concerned about these delicate details at every moment.

Generally, we want the workflows to be parametrized. Non-parametrized but strickly repeatable notebooks are equivalent to their output data.

One way to create them in ODA is to build **jupyter notebook**.

## Simple ODA Jupyter Notebook to a workflow

### Write a working repeatable workflow

First you need to make sure your notebook runs in a cloud environment. It needs to be repeatable - i.e. you can run it many times. If it depends on external services - try to make sure the requests are also repeatable - you might need to specify sufficient details. If the notebook does not produce the exactly
the same result every time - it's unfortunate, but do not worry too much, it might still be reproducible (see motivation on [the difference between reproducibility and repeatability](https://github.com/volodymyrss/reproducibility-motivation/))

* write your notebook, and make sure it runs from top to bottom
* make a requirements.txt will the modules you need for this notebook

You can use a mock [lightcurve notebook](https://renkulab.io/gitlab/astronomy/mmoda/lightcurve-example) as an example.

### Parametetrize the notebook 

* create a cell with the following tag "parameters" (see [papermill manual](https://papermill.readthedocs.io/en/latest/usage-parameterize.html#designate-parameters-for-a-cell)):

### Annotate the notebook outputs

* define the notebook output, similarly creating cell with tag "outputs". 
  * outputs may be strings, floats, lists
  * outputs may be also strings which contain filenames for valid files. If they do, the whole file will be considered output.
* if you want to give more detailed description of the notebook input and output, use `terms` from the [ontology](docs/guide-ontology.).

### (optional) Try a test service

<details>
  <summary markdown="span">Try a test service</summary>
* install nb2workflow tooling `pip install nb2workflow[cwl,oda] --upgrade`
* inspect the notebook `nbinspect my-notebook.ipynb`
* try to run the notebook `nbrun my-notebook.ipynb`
  * it will use all default parameters 
  * you can specify parameters as `nbrun --inp-nbins=10 my-notebook.ipynb`, if `nbins` happens to be one of the parameters.
* try to start the service `nb2service my-notebook.ipynb`
</summary>

### (optional) Add some verification test cases

<details>
  <summary markdown="span">Add some verification test cases</summary>
To make sure your service does not break with future updates, it's useful to express some assumptions about the service outputs in some reference cases.
They will be tested automatically every time new workflow version is installed.

we will explain later how to do this.
</details>

### Publish your workflow as a test service
* publish the workflow to RenkuLab in the dedicated group: https://renkulab.io/gitlab/astronomy/mmoda/
* once some bots do their job, the workflow will be automatically installed in [MMODA](https://www.astro.unige.ch/mmoda)!


### Try to access your new service

Assuming `lightcurve-example` from above was used, and the notebook name was `random`, you can run this:

```bash
oda-api get  -i lightcurve-example -p random -a T1_isot=30000
```

