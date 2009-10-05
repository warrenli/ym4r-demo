# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_coffee_house_session',
  :secret      => 'f7b7c95815b97c00fb6d2468abf834ee4008d5ef8ae012002c189a3004ac22a296d59925aff1cebf742740e274b374e5b878f02ca2c908a3c324ecfb3bd214df'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
