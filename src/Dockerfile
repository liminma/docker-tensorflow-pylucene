ARG BASE_CONTAINER=jupyter/tensorflow-notebook
ARG CONTAINER_VERSION=tensorflow-2.6.2

FROM $BASE_CONTAINER:$CONTAINER_VERSION

USER root

# install OS dependencies
RUN apt-get update --yes && \
    apt-get install --yes --no-install-recommends \
    ant \
    curl \
    g++ \
    gcc \
    make \
    openjdk-8-jdk \
    openjdk-8-jre

# configure Java 8
WORKDIR /usr/lib/jvm
RUN update-java-alternatives -s java-1.8.0-openjdk-amd64
RUN rm -f default-java \
    && ln -s java-1.8.0-openjdk-amd64 default-java

# compile and install PyLucene
WORKDIR /usr/src/pylucene
RUN curl https://downloads.apache.org/lucene/pylucene/pylucene-8.11.0-src.tar.gz \
    | tar -xvz --strip-components=1
RUN cd jcc \
    && NO_SHARED=1 JCC_JDK=/usr/lib/jvm/default-java python setup.py install

ENV ANT=ant PYTHON=python JCC="python -m jcc"
RUN make all install NUM_FILES=10

# override jupyter lab default theme
WORKDIR ${CONDA_DIR}/share/jupyter/lab/settings
ADD overrides.json .
RUN fix-permissions "${CONDA_DIR}" && \
    chown ${NB_UID} ${CONDA_DIR}/share/jupyter/lab/settings -R && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Switch back to $NB_UID
USER ${NB_UID}
WORKDIR "${HOME}"
