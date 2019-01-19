FROM leodotcloud/swiss-army-knife:v0.3

RUN apt-get update && \
    apt-get install -y \
      gosu && \
    rm -rf /var/lib/apt/lists/*

COPY add_ssh_key.sh /usr/bin/

CMD ["add_ssh_key.sh"]
