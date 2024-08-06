# Use an official Ruby runtime as a parent image
FROM ruby:3.2.2

# Set the working directory in the container
WORKDIR /app

# Copy the Gemfile and Gemfile.lock into the container
COPY Gemfile Gemfile.lock ./

# Install dependencies
RUN bundle install

# Copy the rest of the application code into the container
COPY . .

# Make the calculate script executable
RUN chmod +x bin/calculate

# Set the entry point to the calculate script
ENTRYPOINT ["./bin/calculate"]
