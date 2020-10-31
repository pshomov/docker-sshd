FROM debian:10.6

RUN apt-get update && apt-get install -y \
    curl openssh-server mosh \
 && rm -rf /var/lib/apt/lists/*

RUN mkdir /var/run/sshd \
    && echo 'AuthorizedKeysFile %h/.ssh/authorized_keys' >> /etc/ssh/sshd_config \
    && sed -i 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' /etc/pam.d/sshd \
    && sed -ri 's/^PermitRootLogin\s+.*/PermitRootLogin no/' /etc/ssh/sshd_config \
    && sed -ri 's/UsePAM yes/UsePAM no/g' /etc/ssh/sshd_config

COPY start.sh /bin/start.sh
RUN chmod +x /bin/start.sh
RUN groupadd ops-user --gid 1000
RUN useradd -m ops-user --uid 1000 --gid ops-user
ENTRYPOINT ["/bin/start.sh"]
EXPOSE 22
