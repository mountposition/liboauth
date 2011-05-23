# encoding: utf-8
$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__) + '/lib')
require 'benchmark'
require 'oauth'
require 'net/http'
require 'liboauth'

# for oauth
request = Net::HTTP::Get.new('/photos?file=vacation.jpg&size=original&oauth_version=1.0&oauth_consumer_key=dpf43f3p2l4k3l03&oauth_token=nnch734d00sl2jdk&oauth_timestamp=1191242096&oauth_nonce=kllo9940pd9333jh&oauth_signature_method=HMAC-SHA1')

consumer = OAuth::Consumer.new('dpf43f3p2l4k3l03', 'kd94hf93k423kf44')
token = OAuth::Token.new('nnch734d00sl2jdk', 'pfkkdhi9sl3r4s00')

# for liboauth
url = 'http://os.gree.jp/api/rest/people/@me/@self?key1=value1&key2=value2&oauth_nonce=CqWLVz8GkaL&oauth_timestamp=1272026745&xoauth_requestor_id=0123456'
oauth_consumer_key = 'd308e3ccg59e'
oauth_consumer_secret = 'd522g1ab4ke93kdie748g719g07a781c'
oauth_token = 'abcdefghi'
oauth_token_secret = 'jklmnopqrstu'

LOOP_COUNT = 10000

puts "loop #{LOOP_COUNT} times"
Benchmark.bm do |x|
    x.report('oauth') do
        LOOP_COUNT.times do 
            OAuth::Signature.sign(request, { :consumer => consumer,
                                  :token => token,
                                  :uri => 'http://photos.example.net/photos' } )
        end
    end

    x.report('libauth') do
        LOOP_COUNT.times do
            Liboauth.sign_url(url, 'GET', oauth_consumer_key, oauth_consumer_secret, oauth_token, oauth_token_secret )
        end
    end
end
