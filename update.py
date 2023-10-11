import requests
import sys

def check_email_address(email):
  if not [[ email =~ r'^[a-zA-Z0-9\.\_%\\\+\\\-]+\@[a-zA-Z0-9\.\-\]+\.[a-zA-Z]{2,} ]]; then
    print("Invalid email address.")
    sys.exit(1)

def check_phone_number(phone_number):
  if not [[ phone_number =~ r'^\+\\\\\[0\-9\]\{1,3\}\[0\-9\]\{7,14\} ]]; then
    print("Invalid phone number.")
    sys.exit(1)

def get_otp(has_otp):
  if has_otp == "y":
    otp = input("Enter the OTP you have already tried: ")
    if otp:
      return otp
  return ""

def get_headers_and_cookies(url):
  headers = {
    "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/105.0.0.0 Safari/537.36"
  }
  response = requests.get(url, headers=headers)
  cookies = response.cookies.get("datr") + "|" + response.cookies.get("c_user")
  return headers, cookies

def make_post_request(headers, cookies, post_data, url):
  response = requests.post(url, headers=headers, cookies={"datr": datr, "c_user": c_user}, data=post_data)
  return response.content

def check_otp_correct(response):
  if "Password changed successfully" in response:
    return True
  return False

def main():
  email = input("Enter your email address: ")
  phone_number = input("Enter your phone number: ")
  new_password = input("Enter your new password: ")

  # Check if the email address and phone number are valid
  check_email_address(email)
  check_phone_number(phone_number)

  # Get the OTP from the user if they have it
  otp = get_otp()

  # Get the headers and cookies from the URL
  headers, cookies = get_headers_and_cookies("https://www.facebook.com/recover/code/?ph%5B0%5D={}".format(phone_number))

  # Initiate the password reset
  response = make_post_request(headers, cookies, "", "https://www.facebook.com/recover/initiate")

  # Identify the account
  response = make_post_request(headers, cookies, "", "https://www.facebook.com/ajax/login/help/identify.php")

  # Check the BZ status
  response = make_post_request(headers, cookies, "", "https://www.facebook.com/ajax/bz")

  # Get the recovery code
  response = make_post_request(headers, cookies, "", "https://www.facebook.com/recover/code")

  # Change the password
  response = make_post_request(headers, cookies, f"new_password={new_password}", "https://www.facebook.com/password/change/reason/?next=https://m.facebook.com/composer/mbasic%2F")

  # Check if the password reset was successful
  if not check_otp_correct(response):
    print("Failed to reset password.")
    sys.exit(1)

  print("Password reset successfully!")

if __name__ == "__main__":
  main()
