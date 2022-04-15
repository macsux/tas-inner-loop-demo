FROM mikefarah/yq AS yq
FROM ubuntu
COPY --from=yq /usr/bin/yq /usr/bin/yq
RUN apt-get update
RUN apt-get install curl rsync openssh-client sshpass jq -y
RUN curl -L https://github.com/watchexec/watchexec/releases/download/cli-v1.18.12/watchexec-1.18.12-x86_64-unknown-linux-gnu.deb --output /tmp/watchexec.deb && apt install /tmp/watchexec.deb &&  rm /tmp/watchexec.deb
WORKDIR /usr/local/bin
RUN curl -L "https://packages.cloudfoundry.org/stable?release=linux64-binary&version=v7&source=github" | tar -zx
COPY ./*.sh /
WORKDIR /
#CMD exec /bin/bash -c "trap : TERM INT; sleep infinity & wait"
#ENTRYPOINT ["/bin/bash", "-c", "ls /root/.cf"]
ENTRYPOINT [ "/run.sh" ]
