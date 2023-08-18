# use node 16 alpine image as build image
FROM node:16.20.2 as builder

# create work directory in app folder
WORKDIR /app

# copy over package.json files
COPY package.json /app/
# COPY package-lock.json /app/

# install all depencies
RUN yarn install && yarn cache clean

# copy over all files to the work directory
ADD . /app

# build the project
RUN npm run build

# start final image
FROM node:16-alpine


WORKDIR /app

# copy over build files from builder step
COPY --from=builder /app/.output  /app/.output

# expose the host and port 3000 to the server
ENV HOST 0.0.0.0
EXPOSE 3000

# run the build project with node
ENTRYPOINT ["node", ".output/server/index.mjs"]



# FROM node:20-slim AS base
# ENV PNPM_HOME="/pnpm"
# ENV PATH="$PNPM_HOME:$PATH"
# RUN corepack enable
# COPY . /app
# WORKDIR /app

# FROM base AS prod-deps
# RUN --mount=type=cache,id=pnpm,target=/pnpm/store pnpm install --prod --frozen-lockfile

# FROM base AS build
# RUN --mount=type=cache,id=pnpm,target=/pnpm/store pnpm install --frozen-lockfile
# RUN pnpm run build

# FROM base
# COPY --from=prod-deps /app/node_modules /app/node_modules
# COPY --from=build /app/.output /app/.output
# EXPOSE 3000
# CMD [ "pnpm", "start" ]