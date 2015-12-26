include env.mk

# Change name to your project(s)
# delimit multiple prefixes with "|" like "OTP_A|OTP_B|OTP_C"
OTP_APP_PREFIXES = MY_OTP_APP

show-env:
	@sh -c 'env | sort | grep -E "^($(OTP_APP_PREFIXES))_"'

# Remove `show-env` if you do not want to see the given ENV vars
console: show-env
	@iex -S mix

	# Remove `show-env` if you do not want to see the given ENV vars
prod-console: show-env
	@MIX_ENV=prod mix compile
	@MIX_ENV=prod iex -S mix
