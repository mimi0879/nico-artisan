require 'aeshex'
class Account < ActiveRecord::Base

  def nv
    Nicovideo.new(mail, password)
  end

  def key
    'secret'
  end

  def mail; AESHex.decrypt(c_mail, key); end
  def mail=(s); self.c_mail = AESHex.encrypt(s, key); end
  def password; AESHex.decrypt(c_password, key); end
  def password=(s); self.c_password = AESHex.encrypt(s, key); end

  class << self
    def default
      Account.find :first
    end

    def nv
      default.nv
    end
  end
end
