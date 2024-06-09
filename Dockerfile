
#Dependencias de desarrollo

FROM node:19.2-alpine3.16 as deps
# /app

# cd app
WORKDIR /app

COPY package.json ./
# source de donde lo voy a copiar, el destino es el path relativo al working directory
# como tengo la linea anterior en el working directory solo pongo ./
# Dest /app

RUN npm install
# mira las dependencias y haz la instalacion, eso reconstruye el package-lock y el node_modules








# Build y Tests

FROM node:19.2-alpine3.16 as builder
WORKDIR /app
COPY --from=deps /app/node_modules ./node_modules
COPY . .
RUN npm run test







# dependencias produccion

FROM node:19.2-alpine3.16 as prod-deps

WORKDIR /app

COPY package.json ./
#COPY --from=deps /app/node_modules ./node_modules
#usamos ese mismo workdir q definimos antes y usando el stage de la etapa anterior

RUN npm install --prod










#Runner Ejecutar la app

FROM node:19.2-alpine3.16 as runner


COPY --from=prod-deps /app/node_modules ./node_modules


COPY app.js ./
COPY tasks ./tasks


CMD [ "node", "app.js" ]



