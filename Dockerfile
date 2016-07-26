FROM ubuntu:14.04
MAINTAINER Thomas VIAL

# Update and install packages
RUN apt-get update
RUN apt-get install -y curl zsh git vim
RUN apt-get install -y -q php5-cli php5-curl

RUN mkdir -p /behat/composer

# Create "behat" user with password crypted "behat"
# RUN useradd -d /home/behat -m -s /bin/zsh behat
# RUN echo "behat:behat" | chpasswd

# Behat alias in docker container
ADD behat /behat/behat
RUN chmod +x /behat/behat

# Create a new zsh configuration from the provided template
ADD .zshrc /behat/.zshrc

# Fix permissions
# RUN chown -R behat:behat /home/behat

# Add "behat" to "sudoers"
# RUN echo "behat        ALL=(ALL:ALL) ALL" >> /etc/sudoers

# USER behat
WORKDIR /behat
ENV HOME /behat
ENV PATH $PATH:/behat

# Clone oh-my-zsh
RUN git clone https://github.com/robbyrussell/oh-my-zsh.git /behat/.oh-my-zsh/

# Install Behat
# RUN mkdir /behat/composer
ADD composer.json /behat/composer/composer.json
RUN cd /behat/composer && curl http://getcomposer.org/installer | php
RUN cd /behat/composer && php composer.phar install --prefer-source