FROM node:20-alpine
WORKDIR /app
COPY ksami9812/package*.json ./
RUN npm install
COPY ksami9812/ ./
CMD ["npm", "start"]
