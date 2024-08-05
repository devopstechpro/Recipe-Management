# Use the official Node.js image as the base image
FROM node:18-alpine

# Set the working directory inside the container
WORKDIR /app

# Copy package.json and package-lock.json files
COPY package*.json ./

# Install the application dependencies
RUN npm install

# Copy the application source code into the container
COPY . .

# Expose the port that the application will run on
EXPOSE 22137

# Define the command to run the application
CMD ["npm", "start"]
