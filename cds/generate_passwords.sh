#!/bin/bash

# Function to generate a random 10-character string
generate_random_password() {
  tr -dc 'a-zA-Z0-9' < /dev/urandom | head -c 10
}

# Your YAML file path
yaml_file="data/config/accounts.yaml"

# Loop through each line in the file
while IFS= read -r line; do
  # Check if the line contains "password"
  if [[ $line == *password* ]]; then
    # Extract the current password value
    current_password=$(echo "$line" | awk '{print $2}' FS=": ")
    
    # Generate a random 10-character string
    new_password=$(generate_random_password)
    
    # Replace the current password with the new password
    sed -i "s/$current_password/$new_password/" "$yaml_file"
  fi
done < "$yaml_file"
