FROM debian:10.6

RUN apt-get update && apt-get install -y \
    curl openssh-server mosh \
 && rm -rf /var/lib/apt/lists/*

# Setting up sshd
RUN mkdir /var/run/sshd
COPY sshd_config /etc/ssh/sshd_config
RUN chmod 600 /etc/ssh/sshd_config

# Preparing startup script
COPY start.sh /bin/start.sh
RUN chmod +x /bin/start.sh

# Runtime user
RUN groupadd ops-users --gid 1000
RUN useradd -m ops-user --uid 1000 --gid ops-users

ENTRYPOINT ["/bin/start.sh"]
EXPOSE 22
