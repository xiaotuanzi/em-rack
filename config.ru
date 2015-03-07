#!/usr/bin/ruby
# -*- coding: utf-8 -*-

require "eventmachine"
require "em-http"
require "em-synchrony"
require "em-synchrony/em-http"
require "rack/async"

class MyRackApp
  def call(env)
    EM::synchrony do
      http = EM::HttpRequest.new("http://example.com").get
      status = 200
      headers = { 'content-type' => 'text/plain' }
      content = http.response_header.inspect + "\n"
      env['async.callback'].call [ status, headers, [ content ] ]  # Rackレスポンスを非同期で返す
    end
    Rack::Async::RESPONSE  # 非同期でレスポンスを返すことをRackに通知
  end
end

# Rack起動
use Rack::Async
run MyRackApp.new
