#!/bin/bash

OK_STRING="\e[42m[OK]\e[0m"
FAIL_STRING="\e[41m[FAIL]\e[0m"

# Get the directory of the script
script_dir=$(dirname "$(readlink -f "$0")")

# Record start time
start_time=$(date +%s)

# Initialize variables
success_count=0
fail_count=0

# Iterate through subfolders
for folder in "$script_dir"/*/; do
    folder_name="${folder%/}"

    # Check if test.sh exists in the current subfolder
    if [ -f "$folder_name/test.sh" ]; then
        # Execute test.sh and capture the exit status
        "$folder_name/test.sh"
        exit_status=$?

        # Display folder name and success/failure status
        echo "Folder: $folder_name"

        if [ $exit_status -eq 0 ]; then
            echo -e "${OK_STRING} Status: Success"
            ((success_count++))
        else
            echo -e "${FAIL_STRING} Status: Failure (Exit code: $exit_status)"
            ((fail_count++))
        fi

        echo "----------------------------------------"
    fi
done


# Record end time
end_time=$(date +%s)

# Calculate total run time
total_time=$((end_time - start_time))

# Display summary
echo "Summary:"
echo "Number of tests executed: $((success_count + fail_count))"
echo "Number of tests executed successfully: $success_count"
echo "Number of tests failed: $fail_count"
echo "Total run time: $total_time seconds"

# Exit with appropriate status
if [ $fail_count -gt 0 ]; then
    echo -e "${FAIL_STRING} Some test scripts failed."
    exit 1
else
    echo -e "${OK_STRING} All tests executed successfully."
    exit 0
fi
