# PAVICS-e2e-workflow-tests
Test user-level workflow.


## Run locally

```
./launchcontainer  # get inside the container providing the runtime environment

./runtest  # run all notebooks under folder notebooks/
./runtest notebooks/hummingbird.ipynb  # run just 1 notebook
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
