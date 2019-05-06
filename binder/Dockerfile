FROM pavics/workflow-tests:190506

USER root

COPY notebooks /notebooks

COPY default_build_params /notebooks
COPY downloadrepos /notebooks

WORKDIR /notebooks

RUN ./downloadrepos; mv -v pavics-sdi-*/docs/source/notebooks/*.ipynb ./; rm -rfv downloadrepos default_build_params pavics-sdi-*; chown -R jenkins:jenkins .

RUN pip install https://github.com/Ouranosinc/xclim/archive/master.tar.gz

USER jenkins
