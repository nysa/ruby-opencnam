module OpenCNAM
  class InvalidPhoneNumberError < OpenCNAMError
    def initialize(phone_number)
      super(:message => "#{phone_number} could not be parsed as a valid US phone number")
    end
  end
end
