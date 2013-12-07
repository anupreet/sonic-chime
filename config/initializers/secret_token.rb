# Be sure to restart your server when you modify this file.

# Make sure your secret_key_base is kept private
# if you're sharing your code publicly, such as by adding
# .secret to your .gitignore file.

SonicChimes::Application.config.secret_key_base = ENV['SECRET_TOKEN']