# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_multisigntest_session',
  :secret      => '1069a71fe2b1be3a4db799e2622d40b21450ee3289d91dbadc54d4796d2ed9b1b16d8005a8342dfbbc93b5a45ea25a9fd37225dd14632a72f5844ae6fdb35446'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
