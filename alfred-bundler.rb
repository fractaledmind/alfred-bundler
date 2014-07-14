#!/bin/ruby

# This is very experimental code written by some people who don't really know ruby well.
# Watch it develop.

# Can we split this into two files like the other bundlers? Then we can abstract it all the
# more in order to make this work out well.

require 'json'
require 'fileutils'
require 'open-uri'

$ab_major_version = 'aries'
$ab_data_dir = File.expand_path(
	"~/Library/Application Support/Alfred 2/Workflow Data/alfred.bundler-#{$ab_major_version}")

###
require 'open-uri'

def server_test( server )
  begin
    true if open( server )
  rescue
    false
  end
end
###

module AlfredBundler

	# Function to get icons from the icon server
	def get_icon(font, color, name)

		# Construct the icon directory
		icon_dir = File.join($ab_data_dir, 'assets/icons', font, color)

		#  Make the icon directory if it doesn't exist
		FileUtils.mkpath(icon_dir) unless File.directory?(icon_dir)

		# Construct the icon path
		icon_path = File.join(icon_dir, name + '.png')

		# The file exists, so we'll just return the path
		return icon_path if File.exists?(icon_path)

		# The file doesn't exist, so we'll have to go through the effort to get it

		# A list of icon servers so that we can have fallbacks
		icon_servers = IO.readlines("meta/icon_servers")

		# Loop through the list of servers until we find one that is working
		icon_servers.each do |x|
			if server_test( x )
				server = x
				break
			else
				server = false
			end
		end

		# So, none of the servers were reachable. So, we exit, disgracefully.
		unless server
			return false
		end
		# Finish constructing the URL
		server = "#{server}/icon/%s/%s/%s"
		icon_url = $server % [font, color, name]
		
		unless 
			# Get the file if it doesn't exist
			open(icon_path, 'wb') do |file|
				file << open(icon_url).read
			end
		end
		icon_path
	end

	def install_bundler()
	# This is the function to install the bundler

	# Bundler Install URLs
	# I added a bundler backup at Bitbucket: https://bitbucket.org/shawnrice/alfred-bundler
	install_urls = [ 'https://github.com/shawnrice/alfred-bundler/tree/aries' ]
	# https://github.com/shawnrice/alfred-bundler/blob/aries/meta/installer.sh
	# https://bitbucket.org/shawnrice/alfred-bundler/get/7c0f71f72bfc.zip
	end

	def _load(name, version, type, json='')
		unless json.nil?
			puts "The file does not exist" unless File.exists?(json)
		end

		# This is the function to load an asset
	end

	def _load_asset()
		# This is done internally
	end

	def _load_asset_inner()
		# This is done even more internally
	end


end




# Can we move this hardcoded URL into the backend? If we want to start to code in "mirror" backups,
# then we should move this to the backend if possible. Actually, we should move all URLs to the
# backend.
# URL template for creating icon URLs. Add `font`, `color`, `name`s
# $ab_icon_url = 'http://icons.deanishe.net/icon/%s/%s/%s'


# name = 'align-center'
# color = 'dd11ee'
# font = 'fontawesome'

# puts get_icon(font, color, name)

# puts check_server( "github.com" )
puts server_test( "http://icons.deanishe.net" )
# http://icons.deanishe.net



