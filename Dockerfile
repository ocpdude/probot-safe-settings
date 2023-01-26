FROM node:19.5-alpine
ENV NODE_ENV production

## Set the Labels
LABEL version="1.0" \
      description="Probot app which is a modified version of Settings Probot GitHub App"

USER node
## Set our working directory
WORKDIR /opt/safe-settings

# We need Python for Probot
USER root
RUN apk add --no-cache make python3 && ln -sf python3 /usr/bin/python
RUN mkdir -p /opt/safe-settings

## These files are copied separately to allow updates
## to the image to be as small as possible
COPY  package.json /opt/safe-settings/
COPY  index.js /opt/safe-settings/
COPY  lib /opt/safe-settings/lib
# Import environment as a k8s secret instead
# oc create secret generic app-env --from-env-file=env
#COPY  .env /opt/safe-settings/

RUN chown -R node:node /opt/safe-settings

RUN mkdir -p /.npm && chgrp -R 0 /.npm && chmod -R g=u /.npm

## Best practice, don't run as `root`
USER node

## Install the app and dependencies
RUN npm install

## This app will listen on port 3000
EXPOSE 3000

## This does not start properly when using the ['npm','start'] format
## so stick with just calling it outright
CMD npm start
