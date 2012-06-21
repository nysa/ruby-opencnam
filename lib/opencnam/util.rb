module OpenCNAM
  module Util
    def self.clean_phone_number(number)
      # Drop all characters except integers
      clean_number = number.to_s
      clean_number.tr!('^0-9', '')
      clean_number = clean_number[-10..-1]

      raise InvalidPhoneNumberError.new(number) if !clean_number || clean_number.length < 10

      clean_number
    end
  end
end
