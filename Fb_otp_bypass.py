import re
import requests
import time

def check_email_address(email):
    if not re.match(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$', email):
        print("Invalid email address.")
        exit(1)

def check_phone_number(phone_number):
    if not re.match(r'^\+[0-9]{1,3}[0-9]{7,14}$', phone_number):
        print("Invalid phone number.")
        exit(1)

def get_otp():
    has_otp = input("Do you have an OTP? (y/n) ")
    if has_otp.lower() == "y":
        otp = input("Enter the OTP you have already tried: ")
        if otp:
            return otp
    return ""

def get_headers_and_cookies():
    headers = requests.get("https://www.facebook.com/recover/code/").headers
    cookies = headers.get('set-cookie')
    return headers, cookies

def make_post_request(headers, cookies, post_data, url):
    response = requests.post(url, headers=headers, cookies={'set-cookie': cookies}, data=post_data)
    return response

def check_otp_correct(response):
    if "Password changed successfully" in response.text:
        return True
    return False

def change_password(headers, cookies, new_password):
    response = requests.post(
        "https://www.facebook.com/change_password/",
        headers=headers,
        cookies={'set-cookie': cookies},
        data={"new_password": new_password}
    )
    return response

def check_password_changed(response):
    if "Password successfully changed" in response.text:
        return True
    return False

def handle_rate_limiting(response):
    if "Too many requests" in response.text:
        print("Rate limited. Retrying in 60 seconds...")
        time.sleep(60)
        return 1
    return 0

def check_password_strength(new_password):
    # Implement password strength checking logic here
    # ...

# Usage:
# email = input("Enter the email address: ")
# phone_number = input("Enter the phone number: ")
# new_password = input("Enter the new password: ")

# Uncomment the above lines and prompt the user for input to use the Python script.

# Call the functions accordingly
# check_email_address(email)
# check_phone_number(phone_number)
# otp = get_otp()
# headers, cookies = get_headers_and_cookies()
# response = make_post_request(headers, cookies, post_data, url)
# password_changed = check_otp_correct(response)
# if password_changed:
#     change_password(headers, cookies, new_password)
#     response = make_post_request(headers, cookies, post_data, url)
#     password_changed = check_password_changed(response)
# handle_rate_limiting(response)
# check_password_strength(new_password)
