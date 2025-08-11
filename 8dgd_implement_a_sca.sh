#!/bin/bash

# Define a function to parse the automation script
parse_script() {
  # Read the script from a file or input
  script=$(cat "$1")

  # Split the script into individual commands
  IFS=';' read -r -a commands <<< "$script"

  # Initialize an array to store parsed commands
  parsed_commands=()

  # Iterate through each command
  for command in "${commands[@]}"; do
    # Split the command into action and arguments
    IFS=' ' read -r -a parts <<< "$command"
    action="${parts[0]}"
    args="${parts[@]:1}"

    # Handle different actions
    case "$action" in
      "print")
        # Append a print statement to the parsed commands
        parsed_commands+=("echo $args")
        ;;
      "sleep")
        # Append a sleep command to the parsed commands
        parsed_commands+=("sleep $args")
        ;;
      "execute")
        # Append an execution command to the parsed commands
        parsed_commands+=("bash -c \"$args\"")
        ;;
      *)
        # Handle unknown actions
        echo "Unknown action: $action" >&2
        exit 1
        ;;
    esac
  done

  # Join the parsed commands into a single string
  parsed_script=$(IFS=';' ; echo "${parsed_commands[*]}")

  # Output the parsed script
  echo "$parsed_script"
}

# Test the parser function
script_file="example_script.txt"
parsed_script=$(parse_script "$script_file")
echo "Parsed script: $parsed_script"