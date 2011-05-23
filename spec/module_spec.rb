# encoding: utf-8

require 'rspec'
require 'liboauth'

# @see https://developer.gree.co.jp/?mode=home&act=document_platform_oauth
describe Liboauth do
    it 'should sign GREE request type url' do
        url = 'http://os.gree.jp/api/rest/people/@me/@self?key1=value1&key2=value2&oauth_nonce=CqWLVz8GkaL&oauth_timestamp=1272026745&xoauth_requestor_id=0123456'
        oauth_consumer_key = 'd308e3ccg59e'
        oauth_consumer_secret = 'd522g1ab4ke93kdie748g719g07a781c'
        oauth_token = 'abcdefghi'
        oauth_token_secret = 'jklmnopqrstu'
        r = Liboauth.sign_url(url, 'GET', oauth_consumer_key, oauth_consumer_secret, oauth_token, oauth_token_secret )

        r.should_not be_nil
        r[:request_url].should_not be_nil
        r[:request_url].should_not be_include('oauth_')
        r[:request_url].should_not be_include('xoauth_requestor_id="0123456"')
        r[:oauth_header].should_not be_nil
        r[:oauth_header].should be_include('oauth_signature="McJbJB9kwTKOWSwVVf4FbWiCWNw%3D"')
        r[:oauth_header].should be_include('xoauth_requestor_id="0123456"')
    end

    it 'should sign GREE batch type url' do
        url = 'http://os.gree.jp/api/rest/messages/@me/@outbox?key1=value1&key2=value2&oauth_nonce=CqWLVz8GkaL&oauth_timestamp=1272026745'
        oauth_consumer_key = 'd308e3ccg59e'
        oauth_consumer_secret = 'd522g1ab4ke93kdie748g719g07a781c'
        oauth_token =  nil
        oauth_token_secret = nil
        r = Liboauth.sign_url(url, 'POST', oauth_consumer_key, oauth_consumer_secret, oauth_token, oauth_token_secret )

        r.should_not be_nil
        r[:request_url].should_not be_nil
        r[:request_url].should_not be_include('oauth_')
        r[:oauth_header].should_not be_nil
        r[:oauth_header].should be_include('oauth_signature="M9ze2lZVQtihERXXXcdkcReG7e8%3D"')
    end

    it 'should generate nonce and timestamp' do
        url = 'http://os.gree.jp/api/rest/people/@me/@self?key1=value1&key2=value2&xoauth_requestor_id=0123456'
        oauth_consumer_key = 'd308e3ccg59e'
        oauth_consumer_secret = 'd522g1ab4ke93kdie748g719g07a781c'
        oauth_token = 'abcdefghi'
        oauth_token_secret = 'jklmnopqrstu'
        r = Liboauth.sign_url(url, 'GET', oauth_consumer_key, oauth_consumer_secret, oauth_token, oauth_token_secret )

        r[:oauth_header].should be_include('oauth_nonce=')
        r[:oauth_header].should be_include('oauth_timestamp=')
    end

end
