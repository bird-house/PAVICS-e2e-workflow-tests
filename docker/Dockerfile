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
