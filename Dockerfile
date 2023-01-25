FROM node:19.5-alpine
ENV NODE_ENV production

## Set the Labels
LABEL version="1.0" \
      description="Probot app which is a modified version of Settings Probot GitHub App"

# We need Python for Probot
USER root
RUN apk add --no-cache make python3 && ln -sf python3 /usr/bin/python
RUN mkdir -p /opt/safe-settings && chown node /opt/safe-settings

## These files are copied separately to allow updates
## to the image to be as small as possible
COPY  package.json /opt/safe-settings/
COPY  index.js /opt/safe-settings/
COPY  lib /opt/safe-settings/lib
COPY  .env /opt/safe-settings/

## Best practice, don't run as `root`
USER node

## Set our working directory
WORKDIR /opt/safe-settings

## Install the app and dependencies
RUN npm install

## This app will listen on port 3000
EXPOSE 3000

## This does not start properly when using the ['npm','start'] format
## so stick with just calling it outright
CMD npm start
