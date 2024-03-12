FROM ubuntu:jammy
# 备份原始安装源
RUN cp /etc/apt/sources.list /etc/apt/sources.list.bak
# 修改为国内源
#RUN sed -i 's/archive.ubuntu.com/mirrors4.tuna.tsinghua.edu.cn/g' /etc/apt/sources.list
#RUN sed -i 's/security.ubuntu.com/mirrors4.tuna.tsinghua.edu.cn/g' /etc/apt/sources.list

# Update the system, install OpenSSH Server, and set up users
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y openssh-server sudo ffmpeg mediainfo ncdu

# Create user and set password for user and root user
RUN  useradd -rm -d /home/ubuntu -s /bin/bash -g root -G sudo -u 1000 ubuntu && \
    echo 'ubuntu:163453' | chpasswd && \
    echo 'root:163453' | chpasswd

# Set up configuration for SSH
RUN mkdir /var/run/sshd && \
    sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd && \
    echo "export VISIBLE=now" >> /etc/profile

# Expose the SSH port
EXPOSE 22

# Run SSH
CMD ["/usr/sbin/sshd", "-D"]