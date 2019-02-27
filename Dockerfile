FROM conda/miniconda3

RUN conda update conda

ADD https://raw.githubusercontent.com/bird-house/birdy/master/environment.yml /environment-birdy.yml

# create env "birdy"
RUN conda env create -f /environment-birdy.yml

# install using same channel preferences as birdy original env to not downgrade
# anything accidentally
RUN conda install -n birdy -c birdhouse -c conda-forge -c default pytest nbval

# needed for our specific jenkins
RUN groupadd --gid 1000 jenkins \
    && useradd --uid 1000 --gid jenkins --create-home jenkins
