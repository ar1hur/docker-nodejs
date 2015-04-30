# Mount sourcecode
# docker run -p 80:80 -p 443:443 -it -v ~/docker/src:/var/www/workspace testinstance bash
FROM ubuntu

# Base install
RUN apt-get update -y
RUN apt-get install -y vim git-core build-essential g++ libssl-dev curl wget libxml2-dev

# Install NVM
RUN git clone https://github.com/creationix/nvm.git /.nvm
RUN echo ". /.nvm/nvm.sh" >> /etc/bash.bashrc

# Create user
RUN groupadd develop
RUN adduser www
RUN adduser www develop

# Install node.js
ENV NODE_VERSION="v0.12.2"
ENV NODE_PATH="/.nvm/versions/node/$NODE_VERSION/bin"
RUN /bin/bash -c '. /.nvm/nvm.sh && nvm install $NODE_VERSION && nvm use $NODE_VERSION && ln -s $NODE_PATH/node /usr/bin/node && ln -s $NODE_PATH/npm /usr/bin/npm'

# Install packages
RUN npm install -g pm2

# Create the workspace
ENV SRC_PATH="/var/www/workspace"
RUN mkdir -p -m 774 $SRC_PATH
RUN chown root:develop $SRC_PATH

EXPOSE 80
#RUN ls -la "$SRC_PATH/index.js"
#CMD ["pm2", "start", "$SRC_PATH/index.js", "--watch"]
