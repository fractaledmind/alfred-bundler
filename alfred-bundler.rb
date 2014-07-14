#!/bin/ruby

# This is very experimental code written by some people who don't really know ruby well.
# Watch it develop.

# Can we split this into two files like the other bundlers? Then we can abstract it all the
# more in order to make this work out well.

require 'json'
require 'fileutils'
require 'open-uri'



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

module Alfred

	class Bundler

		def initialize
			@major_version = "aries"
			@data = File.expand_path(
				"~/Library/Application Support/Alfred 2/Workflow Data/alfred.bundler-@major_version")
		end

		# Function to get icons from the icon server
		def get_icon(font, color, name)

			# Construct the icon directory
			icon_dir = File.join(@data, 'assets/icons', font, color)

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
			server = icon_servers.each do |x|
				if server_test( x )
					break x
				end
			end
			
			# So, none of the servers were reachable. So, we exit, disgracefully.
			unless :server
				return false
			end
			# Finish constructing the URL
			icon_url = "#{server}/icon/#{font}/#{color}/#{name}"
			
			unless 
				# Get the file if it doesn't exist
				open(icon_path, 'wb') do |file|
					file << open(icon_url).read
				end
			end
			icon_path
		end
	
		# This is the function to install the bundler
		def install_bundler()
			# Make the bundler path
			FileUtils.mkpath(@data) unless File.directory?(@data)

			# Check for an Internet connection
			unless server_test( "http://www.google.com" )
				abort("ERROR: Cannot install Alfred Bundler because there is no Internet connection.")
			end

			require 'uri'

			# Bundler Install URLs
			# I added a bundler backup at Bitbucket: https://bitbucket.org/shawnrice/alfred-bundler
			bundler_urls = IO.readlines("meta/bundler_servers")
			url = bundler_urls.each do |x|
				server = URI.parse(x)
				if server_test("#{server.scheme}://#{server.host}")
					break x
				end
			end
			url
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

end


name = 'align-center'
color = '2321ee'
font = 'fontawesome'

icon = Alfred::Bundler.new
puts icon.install_bundler
# puts icon.get_icon(font, color, name)

# puts check_server( "github.com" )
# puts server_test( "http://icons.deanishe.net" )
# http://icons.deanishe.net



