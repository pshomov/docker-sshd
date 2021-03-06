FROM debian:10.6 as base

RUN apt-get update && apt-get install -y --no-install-recommends \
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
RUN useradd -m ops-user -s /bin/bash --uid 1000 --gid ops-users

ENTRYPOINT ["/bin/start.sh"]
EXPOSE 22

FROM base
RUN apt-get update && apt-get install -y --no-install-recommends \
    git unzip rsync less python3-pip \
 && rm -rf /var/lib/apt/lists/*

# Setting up tfenv
USER ops-user
RUN git clone https://github.com/tfutils/tfenv.git ~/.tfenv \
    && echo 'export PATH="$HOME/.tfenv/bin:$HOME/.local/bin:$PATH"' >> ~/.bash_profile

RUN pip3 install --user aws-export-credentials
USER root
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o ~/awscliv2.zip && \
  cd ~ && unzip awscliv2.zip && \
  ./aws/install && \
  rm awscliv2.zip && rm -rf aws
