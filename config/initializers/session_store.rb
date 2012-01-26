# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_easygilt_session',
  :secret      => '38f9d8d72c2df163a013f0cd77dd5d2a2dabf37480d32ffd0b883f026fce27ffb37b467a5f7bdf6e3711637db861e7f202cee03ac98187ce9b137173d71c0d16'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
