require 'open3'

class SMCGenerator
  JAVASCRIPT = :javascript
  SWIFT = :swift

  def generate(type, smc)
    option = case type
               when JAVASCRIPT
                 '--javascript'
               when SWIFT
                 '--swift'
               else
                 raise ArgumentError("Unknown type #{type}")
             end

    path = "#{Rails.root}/bin/smc_compiler"
    stdout, stderr, status = Open3.capture3("#{path} #{option}", :stdin_data => smc)
    if status == 0
      return stdout
    else
      raise ConvertError(stderr)
    end
  end

  class ConvertError < Exception
  end
end