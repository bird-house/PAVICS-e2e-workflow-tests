FROM conda/miniconda3

RUN conda update conda

COPY environment.yml /environment.yml

# create env "birdy"
RUN conda env create -f /environment.yml

# to checkout other notebooks
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y git mercurial && \
    apt-get clean

# needed for our specific jenkins
RUN groupadd --gid 1000 jenkins \
    && useradd --uid 1000 --gid jenkins --create-home jenkins

# alternate way to 'source activate birdy'
ENV PATH="/usr/local/envs/birdy/bin:$PATH"

# our notebooks are hardcoded to lookup for kernel named 'birdy'
# this python is from the birdy env above
RUN python -m ipykernel install --name birdy

# install using same channel preferences as birdy original env to not downgrade
# anything accidentally
# this is for debug only, all dependencies should be specified in
# environment.yml above
# RUN conda install -n birdy -c birdhouse -c conda-forge -c defaults nbdime

# build jupyterlab extensions installed by conda, see `jupyter labextension list`
RUN jupyter lab build

ADD https://raw.githubusercontent.com/jupyter/docker-stacks/master/base-notebook/start.sh /usr/local/bin/
ADD https://raw.githubusercontent.com/jupyter/docker-stacks/master/base-notebook/start-singleuser.sh /usr/local/bin/
ADD https://raw.githubusercontent.com/jupyter/docker-stacks/master/base-notebook/start-notebook.sh /usr/local/bin/
ADD https://raw.githubusercontent.com/jupyter/docker-stacks/master/base-notebook/fix-permissions /usr/local/bin/
ADD https://raw.githubusercontent.com/jupyter/docker-stacks/master/base-notebook/jupyter_notebook_config.py /etc/jupyter/
RUN chmod a+rx /usr/local/bin/start.sh /usr/local/bin/start-singleuser.sh /usr/local/bin/start-notebook.sh /usr/local/bin/fix-permissions; \
    chmod a+r /etc/jupyter/jupyter_notebook_config.py

# problem running start-notebook.sh when being root
# the jupyter/base-notebook image also do not default to root user so we do the same here
USER jenkins

# follow jupyter/base-notebook image so config in jupyterhub is simpler
CMD ["/usr/local/bin/start-notebook.sh"]
