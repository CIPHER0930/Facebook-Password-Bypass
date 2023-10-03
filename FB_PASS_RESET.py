import requests
from getpass import getpass

def reset_facebook_password(email, password_reset_code):
    """Resets a Facebook password using a password reset code.

    Args:
        email: The email address associated with the Facebook account.
        password_reset_code: The password reset code sent by Facebook.

    Returns:
        True if the password was reset successfully, False otherwise.
    """

    url = "https://www.facebook.com/recover/password"
    payload = {
        "email": email,
        "password_new": password_reset_code,
    }

    response = requests.post(url, data=payload)

    if response.status_code == 200:
        return True
    else:
        return False

if __name__ == "__main__":
    email = input("Enter your Facebook email address: ")
    password_reset_code = getpass("Enter your Facebook password reset code: ")

    success = reset_facebook_password(email, password_reset_code)

    if success:
        print("Your Facebook password has been reset successfully.")
    else:
        print("An error occurred while resetting your Facebook password. Please try again.")
