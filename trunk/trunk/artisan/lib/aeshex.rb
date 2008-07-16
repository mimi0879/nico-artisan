# aeshex.rb
require 'openssl'
module AESHex

  class Error < RuntimeError; end

  def self.key=(str)
    @@encrypter = nil
    @@decrypter = nil
    @@key = str.to_s
  end

private
  def self.key
    @@key
  rescue NameError => e
    raise AESHex::Error.new('The key is not specified.')
  end

  def self.cipher
    OpenSSL::Cipher::Cipher.new("AES-256-CBC")
  end

  def self.encrypter
    if key && @@encrypter.nil?
      @@encrypter = cipher
      @@encrypter.encrypt
      @@encrypter.pkcs5_keyivgen(key)
    end
    @@encrypter
  end

  def self.decrypter
    if key && @@decrypter.nil?
      @@decrypter = cipher
      @@decrypter.decrypt
      @@decrypter.pkcs5_keyivgen(key)
    end
    @@decrypter
  end

  def self.clear
    @@decrypter = @@encrypter = nil
  end

public
  def self.encrypt(str, key_str=nil)
    self.key = key_str if key_str
    clear
    return "" if str.to_s.empty?
    result = encrypter.update(str.to_s)
    result << encrypter.final
    result.unpack("H*")[0]
  end

  def self.decrypt(str, key_str=nil)
    self.key = key_str if key_str
    clear
    return "" if str.to_s.empty?
    result = decrypter.update([str.to_s].pack("H*"))
    result << decrypter.final
    result
  end

  def self.included(receiver)
    String.class_eval <<-EVAL

def encrypt
  AESHex.encrypt(self)
end

def decrypt
  AESHex.decrypt(self)
end

EVAL
  end
end
