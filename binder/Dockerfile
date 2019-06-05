FROM pavics/workflow-tests:190605.1

USER root

COPY notebooks /notebooks

COPY default_build_params /notebooks
COPY downloadrepos /notebooks
COPY binder/reorg-notebooks /notebooks

WORKDIR /notebooks

RUN ./downloadrepos; ./reorg-notebooks; rm -rfv downloadrepos default_build_params reorg-notebooks; chown -R jenkins:jenkins .

RUN pip install https://github.com/Ouranosinc/xclim/archive/master.tar.gz

USER jenkins
