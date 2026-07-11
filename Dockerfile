FROM node:16-slim

WORKDIR /usr/src/app

# Instala dependências do backend
COPY package*.json ./
RUN npm install --loglevel=error

# Instala dependências do frontend
COPY client/package*.json ./client/
RUN cd client && npm install --loglevel=error

# Copia o restante do projeto
COPY . .

# Build do React
RUN REACT_APP_API_URL=http://localhost:3001 \
    SKIP_PREFLIGHT_CHECK=true \
    npm run build --prefix client

# Move o build para a estrutura esperada pela aplicação
RUN mv client/build build && \
    rm -rf client/* && \
    mv build client/

EXPOSE 8080

CMD ["npm", "start"]
