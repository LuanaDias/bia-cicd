FROM node:20-slim

WORKDIR /usr/src/app

# Backend
COPY package*.json ./
RUN npm install --loglevel=error

# Frontend
COPY client/package*.json ./client/
RUN cd client && npm install --loglevel=error

# Código
COPY . .

# Build React
RUN REACT_APP_API_URL=http://localhost:3001 \
    SKIP_PREFLIGHT_CHECK=true \
    npm run build --prefix client

RUN mv client/build build
RUN rm -rf client/*
RUN mv build client/

EXPOSE 8080

CMD ["npm", "start"]
