FROM ubuntu:24.04

ENV LANG="en_US.UTF-8"
ENV PATH="/root/.local/bin:$PATH"

ARG TAMARIN_VERSION="1.10.0"

WORKDIR /root
RUN apt-get update --yes
RUN apt-get install --yes wget
RUN apt-get install --yes libz-dev
RUN apt-get install --yes maude
RUN apt-get install --yes haskell-stack
RUN apt-get install --yes locales
RUN apt-get install --yes netbase
RUN apt-get install --yes graphviz
RUN stack upgrade
RUN locale-gen "en_US.UTF-8"
RUN useradd -ms /bin/bash user
# alternatively, get tamarin source code from official repository
# RUN wget https://github.com/tamarin-prover/tamarin-prover/releases/download/1.10.0/tamarin-prover-1.10.0-linux64-ubuntu.tar.gz
COPY libraries/tamarin-prover-${TAMARIN_VERSION}-linux64-ubuntu.tar.gz /root
RUN tar xzf tamarin-prover-${TAMARIN_VERSION}-linux64-ubuntu.tar.gz
RUN rm tamarin-prover-${TAMARIN_VERSION}-linux64-ubuntu.tar.gz
RUN mv tamarin-prover /usr/local/bin
USER user

VOLUME /workspace
WORKDIR /workspace

EXPOSE 3001
USER user

ENTRYPOINT ["tamarin-prover"]
CMD ["interactive", "--derivcheck-timeout=0", "--quit-on-warning", "."]
