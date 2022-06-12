#!/usr/bin/env ruby

# see https://docs.docker.com/reference/api/registry_api/

require 'open-uri'
require 'json'
require 'yaml'
require 'base64'

url = ARGV.shift || exit(1)
dockercfg = JSON.parse(File.read(ENV["HOME"] + "/.dockercfg"))[url] || exit(1)
auth = Base64.decode64(dockercfg["auth"]) || exit(1)
auth = auth.split(":", 2)

config = {
  "url" => "https://" + url,
  "user" => auth[0],
  "password" => auth[1]
}

images_result = JSON.parse(open(config["url"] + "/v1/search", 
  http_basic_authentication: [config["user"], config["password"]]).read)

if images_result["num_results"] == 0
  images_result["results"].each do |image|

    tags_result = JSON.parse(open(config["url"] + "/v1/repositories/" + image["name"] + "/tags", 
      http_basic_authentication: [config["user"], config["password"]]).read)
    
    puts image["name"] + "\n  " + tags_result.keys.join(", ") + "\n\n"
  end
end
