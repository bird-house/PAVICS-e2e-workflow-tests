# PAVICS-e2e-workflow-tests
Test user-level workflow.


## Description
This repo ensure the various Jupyter notebooks run without errors against the
chosen PAVICS server and still produce the same output.

Resulting benefits:

* Those Jupyter notebooks that are the test suite also double as documentation
  for the features provided to the end users.  More incentive to write more
  documentations and more tests since writing one and the other one comes for
  free!

* Those test suite are also useful during upgrade of some parts of the system
  since we are able to target different PAVICS servers with the same test suite.

* Jenkins (see [Jenkinsfile](Jenkinsfile)) is configured to run the test suite
  regularly so we are able to detect regressions on servers or out-of-date
  output or code in the Jupyter notebooks.  No more mismatched, outdated
  documentation!

* Indirectly this also serve as a monitoring tool for the servers.  Standard
  monitoring tools normally just ensure the services are up and running.  This
  will actually monitor that the most useful and frequently used user workflows
  are working end-to-end.

[pytest](https://pytest.org/) is used as test framework together with
[nbval](https://github.com/computationalmodelling/nbval) pytest plugin to
validate Jupyter notebooks.


## Run locally

```
./launchcontainer  # get inside the container providing the runtime environment

./runtest  # run all notebooks under folder notebooks/
./runtest notebooks/hummingbird.ipynb  # run just 1 notebook

# download more repos containing notebooks (ex: pavics-sdi)
./downloadrepos

# run all notebooks from pavics-sdi
./runtest 'pavics-sdi-master/docs/source/notebooks/*.ipynb'

# run against another PAVICS host than pavics.ouranos.ca
# this assume the PAVICS host hardcoded inside the notebooks is pavics.ouranos.ca
PAVICS_HOST=host.example.com ./runtest

# disable SSL cert verification for notebooks that support this flag
# useful together with PAVICS_HOST to hit hosts using self-signed SSL cert
DISABLE_VERIFY_SSL=1 ./runtest

# save output of test run as a notebook, ending with .outout.ipynb
# each input notebook will have corresponding .output.ipynb file under
#   buildout/ dir
# CAVEAT:
#   * run time is double as a different run is needed
#   * might not contain the exact same error as the original run since it's a
#     different run
SAVE_RESULTING_NOTEBOOK=true ./runtest
```

## Design considerations

Since the runtime environment is provided by the Docker container, it is not
required to create a conda env to run the tests.

By using the exact same Docker container as the one that Jenkins will use, you
will be guarantied that if a notebook runs locally, it will also run
successfully on Jenkins.

Therefore we do not need to pin any versions in the conda environment.yml file
since the built docker image provided us with pinned version for
reproducibility.

To encourage more notebooks written/contribution, which means more
documentations and more tests, it is easy to add new notebooks and the test
runner can even run notebooks from several external repos (current also
running the notebooks from the
[pavics-sdi](https://github.com/Ouranosinc/pavics-sdi/tree/master/docs/source/notebooks)
repo, more can be added easily).


## Adding more notebooks to tests

Simply add another `.ipynb` file under folder `notebooks/` and it'll be picked
up by the runner.


## Start Jupyter notebook to modify one of the notebooks

```
./launchnotebook [port]
```

then follow the output to open the browser to your local Jupyter instance.

Example output:
```
[I 23:59:44.366 NotebookApp] Writing notebook server cookie secret to /home/jenkins/.local/share/jupyter/runtime/notebook_cookie_secret
[I 23:59:44.591 NotebookApp] Serving notebooks from local directory: /
[I 23:59:44.591 NotebookApp] The Jupyter Notebook is running at:
[I 23:59:44.591 NotebookApp] http://(ebe30a480ccf or 127.0.0.1):8890/?token=22fc0be94eb948977fc235b588116c670beafde4374d8de8
[I 23:59:44.591 NotebookApp] Use Control-C to stop this server and shut down all kernels (twice to skip confirmation).
[C 23:59:44.595 NotebookApp]

    To access the notebook, open this file in a browser:
        file:///home/jenkins/.local/share/jupyter/runtime/nbserver-1-open.html
    Or copy and paste one of these URLs:
        http://(ebe30a480ccf or 127.0.0.1):8890/?token=22fc0be94eb948977fc235b588116c670beafde4374d8de8
```

So you would open
`http://localhost:8890/?token=22fc0be94eb948977fc235b588116c670beafde4374d8de8`
then navigate to
`http://localhost:8890/tree/home/lvu/repos/PAVICS-e2e-workflow-tests/notebooks`
if `/home/lvu/repos/PAVICS-e2e-workflow-tests` is where you have this repo
checked out on your local machine.

To stop the notebook:
```
docker stop birdy-notebook  # the container created by launchnotebook
```


## Releasing a new Docker image

All the steps below can be automated by using the script `releasedocker
<old_ver> <new_ver>`, example: `releasedocker 190311 190312`.

Update `Jenkinsfile`, `launchcontainer`, `launchnotebook` with the soon to
build `pavics/workflow-tests` image tag.

Tag with `docker-YYMMDD` and push and the Docker image tag will be the `YYMMDD` part.

Example:
```
$EDITOR Jenkinsfile launchcontainer launchnotebook
# update to pavics/workflow-tests:190311
git ci -am "update to use image pavics/workflow-tests:190311"
git tag docker-190311
git push
git push --tags
```

Then Docker Hub will build automatically and eventually we have a new image
[`pavics/workflow-tests:190311`](https://hub.docker.com/r/pavics/workflow-tests).
