#!/bin/bash

# Commit message as an input
read -p "Enter commit message: " commit_message

# Add all changes
echo "Staging all changes..."
git add .
if [ $? -ne 0 ]; then
  echo "Failed to stage changes. Exiting."
  exit 1
fi

# Commit the changes
echo "Committing changes with message: $commit_message"
git commit -m "$commit_message"
if [ $? -ne 0 ]; then
  echo "Failed to commit changes. Exiting."
  exit 1
fi

# Push changes to the main branch
echo "Pushing to 'main' branch..."
git push origin main
if [ $? -ne 0 ]; then
  echo "Failed to push changes. Exiting."
  exit 1
fi

echo "All steps completed successfully!"
