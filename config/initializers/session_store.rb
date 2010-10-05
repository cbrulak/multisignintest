# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_multisignintest_session',
  :secret      => 'e5be82cdddc562d7c1e0fc10ac1579bf3c7384411c31bf46d3002aa3c3ce52dcf5e2c6936126459266b1ad39d21d0ccfa3021ce37491f6e698571a1c1123cc10'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
